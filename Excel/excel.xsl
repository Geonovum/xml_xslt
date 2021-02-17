<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:xr="http://schemas.microsoft.com/office/spreadsheetml/2014/revision" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">
  <xsl:output method="text" encoding="windows-1252"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="waarden">
    <xsl:element name="waarde">
      <xsl:for-each select="('Label','Term','URI','Definitie','Toelichting','Bron','Domein','Specialisatie','Symboolcode','Waardelijst')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:for-each select="//waarden/waarde">
      <xsl:element name="waarde">
        <xsl:for-each select="(label,term,uri,definitie,toelichting,bron,domein,specialisatie,symboolcode,ancestor::waardelijst/uri)">
          <xsl:element name="item">
            <xsl:value-of select="./node()"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <xsl:param name="waardelijsten">
    <xsl:element name="waardelijst">
      <xsl:for-each select="('Label','Titel','URI','Type','Omschrijving','Toelichting')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:for-each select="//waardelijsten/waardelijst">
      <xsl:element name="waardelijst">
        <xsl:for-each select="(label,titel,uri,type,omschrijving,toelichting)">
          <xsl:element name="item">
            <xsl:value-of select="./node()"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <xsl:param name="domeinen">
    <xsl:element name="domein">
      <xsl:for-each select="('Label','Term','URI','Omschrijving','Toelichting')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:for-each select="//domeinen/domein">
      <xsl:sort select="term"/>
      <xsl:if test="not(preceding::domeinen/domein[./term=current()/term])">
        <xsl:element name="domein">
          <xsl:variable name="test" select="."/>
          <xsl:for-each select="(label,term,uri,omschrijving,toelichting)">
            <xsl:element name="item">
              <xsl:value-of select="./node()"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:param>

  <xsl:param name="unique_strings" select="fn:distinct-values(($waarden,$waardelijsten,$domeinen)//item[. ne ''])"/>

  <!-- verwerk waardelijsten.xml -->

  <xsl:template match="/">
    <xsl:call-template name="sharedStrings"/>
    <xsl:call-template name="sheet1"/>
    <xsl:call-template name="sheet2"/>
    <xsl:call-template name="sheet3"/>
    <xsl:value-of select="fn:document-uri()"/>
  </xsl:template>

  <xsl:template name="sharedStrings">
    <xsl:result-document href="template/xl/sharedStrings.xml" method="xml" encoding="utf-8" standalone="yes">
      <xsl:element name="sst" xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <xsl:attribute name="count" select="count(($waarden,$waardelijsten,$domeinen)//item[. ne ''])"/>
        <xsl:attribute name="uniqueCount" select="count($unique_strings)"/>
        <xsl:for-each select="$unique_strings">
          <xsl:element name="si">
            <xsl:element name="t">
              <xsl:value-of select="."/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="sheet1">
    <xsl:variable name="ref" select="concat('A1:J',string(count($waarden/waarde)))"/>
    <xsl:result-document href="template/xl/worksheets/sheet1.xml" method="xml" encoding="utf-8" standalone="yes">
      <xsl:element name="worksheet" xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <xsl:namespace name="r" select="string('http://schemas.openxmlformats.org/officeDocument/2006/relationships')"/>
        <xsl:namespace name="mc" select="string('http://schemas.openxmlformats.org/markup-compatibility/2006')"/>
        <xsl:namespace name="x14ac" select="string('http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac')"/>
        <xsl:namespace name="xr" select="string('http://schemas.microsoft.com/office/spreadsheetml/2014/revision')"/>
        <xsl:namespace name="xr2" select="string('http://schemas.microsoft.com/office/spreadsheetml/2015/revision2')"/>
        <xsl:namespace name="xr3" select="string('http://schemas.microsoft.com/office/spreadsheetml/2016/revision3')"/>
        <xsl:attribute name="mc:Ignorable" select="string('x14ac xr xr2 xr3')"/>
        <xsl:attribute name="xr:uid" select="string('{F5367A3A-0989-4B09-A416-81BF867E8888}')"/>
        <xsl:element name="dimension">
          <xsl:attribute name="ref" select="$ref"/>
        </xsl:element>
        <xsl:element name="sheetViews">
          <xsl:element name="sheetView">
            <xsl:attribute name="workbookViewId" select="string('0')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="sheetFormatPr">
          <xsl:attribute name="defaultRowHeight" select="string('14.4')"/>
          <xsl:attribute name="x14ac:dyDescent" select="string('0.3')"/>
        </xsl:element>
        <xsl:element name="cols">
          <xsl:element name="col">
            <xsl:attribute name="min" select="string('1')"/>
            <xsl:attribute name="max" select="string('10')"/>
            <xsl:attribute name="width" select="string('25.77734375')"/>
            <xsl:attribute name="customWidth" select="string('1')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="sheetData">
          <xsl:for-each select="$waarden/waarde">
            <xsl:element name="row">
              <xsl:variable name="ID_row" select="position()"/>
              <xsl:attribute name="r" select="$ID_row"/>
              <xsl:attribute name="spans" select="string('1:10')"/>
              <xsl:attribute name="x14ac:dyDescent" select="string('0.3')"/>
              <xsl:for-each select="./item">
                <xsl:variable name="index" select="position()"/>
                <xsl:variable name="ID_col" select="('A','B','C','D','E','F','G','H','I','J')[$index]"/>
                <xsl:element name="c">
                  <xsl:attribute name="r" select="concat($ID_col,$ID_row)"/>
                  <xsl:attribute name="s" select="string('1')"/>
                  <xsl:attribute name="t" select="string('s')"/>
                  <xsl:if test="text() ne ''">
                    <xsl:element name="v">
                      <xsl:value-of select="fn:index-of($unique_strings,text())-1"/>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="pageMargins">
          <xsl:attribute name="left" select="string('0.7')"/>
          <xsl:attribute name="right" select="string('0.7')"/>
          <xsl:attribute name="top" select="string('0.75')"/>
          <xsl:attribute name="bottom" select="string('0.75')"/>
          <xsl:attribute name="header" select="string('0.3')"/>
          <xsl:attribute name="footer" select="string('0.3')"/>
        </xsl:element>
        <xsl:element name="tableParts">
          <xsl:attribute name="count" select="string('1')"/>
          <xsl:element name="tablePart">
            <xsl:attribute name="r:id" select="string('rId1')"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="sheet2">
    <xsl:result-document href="template/xl/worksheets/sheet2.xml" method="xml" encoding="utf-8" standalone="yes">
      <xsl:element name="worksheet" xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <xsl:namespace name="r" select="string('http://schemas.openxmlformats.org/officeDocument/2006/relationships')"/>
        <xsl:namespace name="mc" select="string('http://schemas.openxmlformats.org/markup-compatibility/2006')"/>
        <xsl:namespace name="x14ac" select="string('http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac')"/>
        <xsl:namespace name="xr" select="string('http://schemas.microsoft.com/office/spreadsheetml/2014/revision')"/>
        <xsl:namespace name="xr2" select="string('http://schemas.microsoft.com/office/spreadsheetml/2015/revision2')"/>
        <xsl:namespace name="xr3" select="string('http://schemas.microsoft.com/office/spreadsheetml/2016/revision3')"/>
        <xsl:attribute name="mc:Ignorable" select="string('x14ac xr xr2 xr3')"/>
        <xsl:attribute name="xr:uid" select="string('{4E326EFB-BCBB-4339-B644-4BD9C41E845E}')"/>
        <xsl:element name="dimension">
          <xsl:attribute name="ref" select="concat('A1:F',string(count($waardelijsten/waardelijst)))"/>
        </xsl:element>
        <xsl:element name="sheetViews">
          <xsl:element name="sheetView">
            <xsl:attribute name="workbookViewId" select="string('0')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="sheetFormatPr">
          <xsl:attribute name="defaultRowHeight" select="string('14.4')"/>
          <xsl:attribute name="x14ac:dyDescent" select="string('0.3')"/>
        </xsl:element>
        <xsl:element name="cols">
          <xsl:element name="col">
            <xsl:attribute name="min" select="string('1')"/>
            <xsl:attribute name="max" select="string('6')"/>
            <xsl:attribute name="width" select="string('25.77734375')"/>
            <xsl:attribute name="customWidth" select="string('1')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="sheetData">
          <xsl:for-each select="$waardelijsten/waardelijst">
            <xsl:element name="row">
              <xsl:variable name="ID_row" select="position()"/>
              <xsl:attribute name="r" select="$ID_row"/>
              <xsl:attribute name="spans" select="string('1:6')"/>
              <xsl:attribute name="x14ac:dyDescent" select="string('0.3')"/>
              <xsl:for-each select="./item">
                <xsl:variable name="index" select="position()"/>
                <xsl:variable name="ID_col" select="('A','B','C','D','E','F')[$index]"/>
                <xsl:element name="c">
                  <xsl:attribute name="r" select="concat($ID_col,$ID_row)"/>
                  <xsl:attribute name="s" select="string('1')"/>
                  <xsl:attribute name="t" select="string('s')"/>
                  <xsl:if test="text() ne ''">
                    <xsl:element name="v">
                      <xsl:value-of select="fn:index-of($unique_strings,text())-1"/>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="pageMargins">
          <xsl:attribute name="left" select="string('0.7')"/>
          <xsl:attribute name="right" select="string('0.7')"/>
          <xsl:attribute name="top" select="string('0.75')"/>
          <xsl:attribute name="bottom" select="string('0.75')"/>
          <xsl:attribute name="header" select="string('0.3')"/>
          <xsl:attribute name="footer" select="string('0.3')"/>
        </xsl:element>
        <xsl:element name="tableParts">
          <xsl:attribute name="count" select="string('1')"/>
          <xsl:element name="tablePart">
            <xsl:attribute name="r:id" select="string('rId1')"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="sheet3">
    <xsl:result-document href="template/xl/worksheets/sheet3.xml" method="xml" encoding="utf-8" standalone="yes">
      <xsl:element name="worksheet" xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <xsl:namespace name="r" select="string('http://schemas.openxmlformats.org/officeDocument/2006/relationships')"/>
        <xsl:namespace name="mc" select="string('http://schemas.openxmlformats.org/markup-compatibility/2006')"/>
        <xsl:namespace name="x14ac" select="string('http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac')"/>
        <xsl:namespace name="xr" select="string('http://schemas.microsoft.com/office/spreadsheetml/2014/revision')"/>
        <xsl:namespace name="xr2" select="string('http://schemas.microsoft.com/office/spreadsheetml/2015/revision2')"/>
        <xsl:namespace name="xr3" select="string('http://schemas.microsoft.com/office/spreadsheetml/2016/revision3')"/>
        <xsl:attribute name="mc:Ignorable" select="string('x14ac xr xr2 xr3')"/>
        <xsl:attribute name="xr:uid" select="string('{45A97900-2A25-47D2-923F-4264A378D198}')"/>
        <xsl:element name="dimension">
          <xsl:attribute name="ref" select="concat('A1:E',string(count($domeinen/domein)))"/>
        </xsl:element>
        <xsl:element name="sheetViews">
          <xsl:element name="sheetView">
            <xsl:attribute name="workbookViewId" select="string('0')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="sheetFormatPr">
          <xsl:attribute name="defaultRowHeight" select="string('14.4')"/>
          <xsl:attribute name="x14ac:dyDescent" select="string('0.3')"/>
        </xsl:element>
        <xsl:element name="cols">
          <xsl:element name="col">
            <xsl:attribute name="min" select="string('1')"/>
            <xsl:attribute name="max" select="string('5')"/>
            <xsl:attribute name="width" select="string('25.77734375')"/>
            <xsl:attribute name="customWidth" select="string('1')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="sheetData">
          <xsl:for-each select="$domeinen/domein">
            <xsl:element name="row">
              <xsl:variable name="ID_row" select="position()"/>
              <xsl:attribute name="r" select="$ID_row"/>
              <xsl:attribute name="spans" select="string('1:5')"/>
              <xsl:attribute name="x14ac:dyDescent" select="string('0.3')"/>
              <xsl:for-each select="./item">
                <xsl:variable name="index" select="position()"/>
                <xsl:variable name="ID_col" select="('A','B','C','D','E')[$index]"/>
                <xsl:element name="c">
                  <xsl:attribute name="r" select="concat($ID_col,$ID_row)"/>
                  <xsl:attribute name="s" select="string('1')"/>
                  <xsl:attribute name="t" select="string('s')"/>
                  <xsl:if test="text() ne ''">
                    <xsl:element name="v">
                      <xsl:value-of select="fn:index-of($unique_strings,text())-1"/>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="pageMargins">
          <xsl:attribute name="left" select="string('0.7')"/>
          <xsl:attribute name="right" select="string('0.7')"/>
          <xsl:attribute name="top" select="string('0.75')"/>
          <xsl:attribute name="bottom" select="string('0.75')"/>
          <xsl:attribute name="header" select="string('0.3')"/>
          <xsl:attribute name="footer" select="string('0.3')"/>
        </xsl:element>
        <xsl:element name="tableParts">
          <xsl:attribute name="count" select="string('1')"/>
          <xsl:element name="tablePart">
            <xsl:attribute name="r:id" select="string('rId1')"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>