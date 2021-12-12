<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:my="http://www.eigen.nl" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- parameters ten behoeve van url's -->
  <xsl:param name="delimiter" select="string('/')"/>
  <xsl:param name="organisatie" select="string('Geonovum')"/>

  <!-- options -->
  <xsl:param name="options" select="document('options.xml')/respec"/>

  <!-- document -->

  <xsl:template match="root()">
    <xsl:variable name="id" select="(w:settings/w:docVars/w:docVar[@w:name='ID003']/@w:val,my:check_string(w:settings/w:docVars/w:docVar[@w:name='ID001']/@w:val),'geen')[1]"/>
    <xsl:variable name="specStatus" select="(w:settings/w:docVars/w:docVar[@w:name='ID005']/@w:val,'Geen')[1]"/>
    <xsl:variable name="publishDate">
      <xsl:choose>
        <xsl:when test="$specStatus='GN-WV'">
          <!-- respec neemt de push-datum (current-date) -->
          <xsl:value-of select="fn:format-date(fn:current-date(),'[Y0001]-[M01]-[D01]')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="fn:format-date((w:settings/w:docVars/w:docVar[@w:name='ID008']/@w:val,fn:current-date())[1],'[Y0001]-[M01]-[D01]')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="config">
      <!-- respec -->
      <xsl:element name="item">
        <xsl:comment>respec</xsl:comment>
        <!-- ingevulde velden -->
        <xsl:if test="w:settings/w:docVars/w:docVar[@w:name='ID002']/@w:val">
          <xsl:element name="subtitle">
            <xsl:value-of select="w:settings/w:docVars/w:docVar[@w:name='ID002']/@w:val"/>
          </xsl:element>
        </xsl:if>
        <xsl:element name="pubDomain">
          <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID004']/@w:val,'Geen')[1]"/>
        </xsl:element>
        <xsl:element name="specStatus">
          <xsl:value-of select="$specStatus"/>
        </xsl:element>
        <xsl:element name="specType">
          <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID006']/@w:val,'Geen')[1]"/>
        </xsl:element>
        <xsl:element name="license">
          <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID007']/@w:val,'Geen')[1]"/>
        </xsl:element>
        <xsl:element name="publishDate">
          <xsl:value-of select="$publishDate"/>
        </xsl:element>
        <xsl:if test="w:settings/w:docVars/w:docVar[@w:name='ID009']/@w:val">
          <xsl:element name="previousPublishDate">
            <xsl:value-of select="w:settings/w:docVars/w:docVar[@w:name='ID009']/@w:val"/>
          </xsl:element>
          <xsl:element name="previousMaturity">
            <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID010']/@w:val,'Geen')[1]"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="number(w:settings/w:docVars/w:docVar[@w:name='ID012']/@w:val) gt 0">
          <xsl:element name="authors">
            <xsl:for-each select="for $index in 1 to w:settings/w:docVars/w:docVar[@w:name='ID012']/@w:val return w:settings/w:docVars/w:docVar[@w:name=concat('ID012',fn:format-number($index,'00'))]/@w:val">
              <xsl:variable name="item" select="fn:tokenize(.,'\|')"/>
              <xsl:element name="item">
                <xsl:element name="name">
                  <xsl:value-of select="$item[1]"/>
                </xsl:element>
                <xsl:element name="company">
                  <xsl:value-of select="$item[2]"/>
                </xsl:element>
                <xsl:element name="companyURL">
                  <xsl:value-of select="$item[3]"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:if>
        <xsl:if test="number(w:settings/w:docVars/w:docVar[@w:name='ID013']/@w:val) gt 0">
          <xsl:element name="editors">
            <xsl:for-each select="for $index in 1 to w:settings/w:docVars/w:docVar[@w:name='ID013']/@w:val return w:settings/w:docVars/w:docVar[@w:name=concat('ID013',fn:format-number($index,'00'))]/@w:val">
              <xsl:variable name="item" select="fn:tokenize(.,'\|')"/>
              <xsl:element name="item">
                <xsl:element name="name">
                  <xsl:value-of select="$item[1]"/>
                </xsl:element>
                <xsl:element name="company">
                  <xsl:value-of select="$item[2]"/>
                </xsl:element>
                <xsl:element name="companyURL">
                  <xsl:value-of select="$item[3]"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:if>
        <xsl:if test="number(w:settings/w:docVars/w:docVar[@w:name='ID014']/@w:val) gt 0">
          <xsl:element name="localBiblio">
            <xsl:for-each select="for $index in 1 to w:settings/w:docVars/w:docVar[@w:name='ID014']/@w:val return w:settings/w:docVars/w:docVar[@w:name=concat('ID014',fn:format-number($index,'00'))]/@w:val">
              <xsl:variable name="item" select="fn:tokenize(.,'\|')"/>
              <xsl:element name="{my:check_string($item[1])}">
                <xsl:element name="title">
                  <xsl:value-of select="$item[1]"/>
                </xsl:element>
                <xsl:element name="href">
                  <xsl:value-of select="$item[2]"/>
                </xsl:element>
                <xsl:element name="authors">
                  <xsl:for-each select="fn:tokenize($item[3],',\s*')">
                    <xsl:element name="item">
                      <xsl:value-of select="."/>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:element>
                <xsl:element name="publisher">
                  <xsl:value-of select="$item[4]"/>
                </xsl:element>
                <xsl:element name="company">
                  <xsl:value-of select="$item[5]"/>
                </xsl:element>
                <xsl:element name="date">
                  <xsl:value-of select="$item[6]"/>
                </xsl:element>
                <xsl:element name="status">
                  <xsl:value-of select="$item[7]"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:if>
        <!-- gegenereerde velden -->
        <xsl:element name="shortName">
          <xsl:value-of select="$id"/>
        </xsl:element>
        <xsl:element name="format">
          <xsl:value-of select="string('markdown')"/>
        </xsl:element>
        <xsl:if test="w:settings/w:docVars/w:docVar[@w:name='ID011']/@w:val = ('Waar','True')">
          <xsl:element name="github">
            <xsl:value-of select="fn:string-join(('https:','','github.com',$organisatie,fn:string-join(((w:settings/w:docVars/w:docVar[@w:name='ID004']/@w:val,'Geen')[1],$id),'-')),$delimiter)"/>
          </xsl:element>
          <xsl:element name="issueBase">
            <xsl:value-of select="fn:string-join(('https:','','github.com',$organisatie,fn:string-join(((w:settings/w:docVars/w:docVar[@w:name='ID004']/@w:val,'Geen')[1],$id),'-'),'issues'),$delimiter)"/>
          </xsl:element>
        </xsl:if>
        <xsl:element name="edDraftURI">
          <xsl:value-of select="fn:string-join(('https:','',fn:string-join(($organisatie,'github','io'),'.'),fn:string-join(((w:settings/w:docVars/w:docVar[@w:name='ID004']/@w:val,'Geen')[1],$id),'-')),$delimiter)"/>
        </xsl:element>
        <xsl:choose>
          <xsl:when test="$specStatus='GN-WV'">
            <!-- respec neemt de push-datum -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="publishISODate">
              <xsl:value-of select="concat(fn:format-date($publishDate,'[Y0001]-[M01]-[D01]'),'T00:00:00.000Z')"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="generatedSubtitle">
          <xsl:value-of select="concat($options/list[@id='specStatus']/item[@id=$specStatus],' ',fn:format-date($publishDate,'[D1] [Mn] [Y1]'))"/>
        </xsl:element>
      </xsl:element>
      <!-- github -->
      <xsl:element name="item">
        <xsl:comment>github</xsl:comment>
        <xsl:element name="repository">
          <xsl:value-of select="fn:string-join(((w:settings/w:docVars/w:docVar[@w:name='ID004']/@w:val,'Geen')[1],$id),'-')"/>
        </xsl:element>
      </xsl:element>
      <!-- snapshot -->
      <xsl:element name="item">
        <xsl:comment>snapshot</xsl:comment>
        <xsl:element name="company">
          <xsl:element name="name">
            <xsl:value-of select="string('Geonovum')"/>
          </xsl:element>
          <xsl:element name="url">
            <xsl:value-of select="string('https://www.geonovum.nl')"/>
          </xsl:element>
          <xsl:element name="docs">
            <xsl:value-of select="string('https://docs.geostandaarden.nl')"/>
          </xsl:element>
          <xsl:element name="tools">
            <xsl:value-of select="string('https://tools.geostandaarden.nl')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="document">
          <xsl:element name="title">
            <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID001']/@w:val,'Geen')[1]"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- routines -->

  <xsl:function name="my:check_string">
    <xsl:param name="string"/>
    <xsl:variable name="result">
      <xsl:for-each select="tokenize(translate(lower-case($string),' ''.-_()','       '),'\s+')">
        <xsl:variable name="codepoints" select="fn:string-to-codepoints(concat(upper-case(substring(.,1,1)),substring(.,2)))"/>
        <xsl:variable name="check_string">
          <xsl:for-each select="$codepoints">
            <xsl:choose>
              <xsl:when test="(. ge 48) and (. le 57)">
                <!-- cijfers -->
                <node><xsl:value-of select="."/></node>
              </xsl:when>
              <xsl:when test="((. ge 65) and (. le 90)) or ((. ge 97) and (. le 122))">
                <!-- letters -->
                <node><xsl:value-of select="."/></node>
              </xsl:when>
              <xsl:when test="(. ge 224) and (. le 230)">
                <!-- a -->
                <node><xsl:value-of select="97"/></node>
              </xsl:when>
              <xsl:when test="(. eq 231)">
                <!-- c -->
                <node><xsl:value-of select="99"/></node>
              </xsl:when>
              <xsl:when test="(. ge 232) and (. le 235)">
                <!-- e -->
                <node><xsl:value-of select="101"/></node>
              </xsl:when>
              <xsl:when test="(. ge 236) and (. le 239)">
                <!-- i -->
                <node><xsl:value-of select="105"/></node>
              </xsl:when>
              <xsl:when test="(. eq 241)">
                <!-- n -->
                <node><xsl:value-of select="110"/></node>
              </xsl:when>
              <xsl:when test="(. ge 242) and (. le 246)">
                <!-- o -->
                <node><xsl:value-of select="111"/></node>
              </xsl:when>
              <xsl:when test="(. ge 249) and (. le 252)">
                <!-- u -->
                <node><xsl:value-of select="117"/></node>
              </xsl:when>
              <xsl:when test="(. eq 253) or (. eq 255)">
                <!-- y -->
                <node><xsl:value-of select="121"/></node>
              </xsl:when>
              <xsl:when test="(. ge 192) and (. le 198)">
                <!-- A -->
                <node><xsl:value-of select="65"/></node>
              </xsl:when>
              <xsl:when test="(. eq 199)">
                <!-- C -->
                <node><xsl:value-of select="67"/></node>
              </xsl:when>
              <xsl:when test="(. ge 200) and (. le 203)">
                <!-- E -->
                <node><xsl:value-of select="69"/></node>
              </xsl:when>
              <xsl:when test="(. ge 204) and (. le 207)">
                <!-- I -->
                <node><xsl:value-of select="73"/></node>
              </xsl:when>
              <xsl:when test="(. eq 209)">
                <!-- N -->
                <node><xsl:value-of select="78"/></node>
              </xsl:when>
              <xsl:when test="(. ge 210) and (. le 214)">
                <!-- O -->
                <node><xsl:value-of select="79"/></node>
              </xsl:when>
              <xsl:when test="(.ge 217) and (. le 220)">
                <!-- U -->
                <node><xsl:value-of select="85"/></node>
              </xsl:when>
              <xsl:when test="(. eq 221)">
                <!-- Y -->
                <node><xsl:value-of select="89"/></node>
              </xsl:when>
              <xsl:otherwise>
                <node><xsl:value-of select="95"/></node>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="fn:codepoints-to-string($check_string/node[(. ne '95') or following::node[. ne '95']])"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>

</xsl:stylesheet>