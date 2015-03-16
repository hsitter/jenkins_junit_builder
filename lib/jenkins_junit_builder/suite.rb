require 'active_support/core_ext/object/blank'
require 'nokogiri'
require 'pathname'
require Pathname.new(__dir__) + 'file_not_found_exception'
require 'pry'

module JenkinsJunitBuilder
  class Suite

    attr_accessor :name, :report_path, :append_report

    def initialize
      @cases             = []
      self.append_report = true
    end

    #
    def add_case(test_case)
      @cases << test_case
    end

    # In short, this is the XML string that makes the report.
    #
    # @return [String] XML report
    def build_report
      # build cases
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.testsuites {
          testsuite        = xml.testsuite {
            @cases.each do |tc|
              testcase             = xml.testcase {
                if tc.result_has_message?
                  result_type           = xml.send(tc.result)
                  result_type[:message] = tc.message if tc.message.present?
                end

                if tc.system_out.size > 0
                  xml.send('system-out') { xml.text tc.system_out.to_s }
                end

                if tc.system_err.size > 0
                  xml.send('system-err') { xml.text tc.system_err.to_s }
                end
              }

              testcase[:name]      = tc.name if tc.name.present?
              testcase[:time]      = tc.time if tc.time.present?
              testcase[:classname] = tc.classname if tc.classname.present?
            end
          }

          testsuite[:name] = name if name.present?
        }
      end

      builder.parent.root.to_xml
    end

    # Writes the report to the specified file
    # also returns the new XML report content
    #
    # @return [String] final XML report content
    def write_report_file
      raise FileNotFoundException.new 'There is no report file path specified' if report_path.blank?

      report = build_report

      if append_report.present? && File.exist?(report_path)
        f            = File.open(report_path)
        existing_xml = Nokogiri::XML(f)
        f.close

        report = existing_xml.root << Nokogiri::XML(report).at('testsuite')

        # formatting
        report = format_xml report.to_xml
      end

      File.write report_path, report
      report
    end

    protected

    # @params [String] XML string
    def format_xml(xml_text)
      xsl =<<XSL
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/">
    <xsl:copy-of select="."/>
  </xsl:template>
</xsl:stylesheet>
XSL

      doc  = Nokogiri::XML(xml_text)
      xslt = Nokogiri::XSLT(xsl)
      out  = xslt.transform(doc)

      out.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::DEFAULT_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
    end

  end
end