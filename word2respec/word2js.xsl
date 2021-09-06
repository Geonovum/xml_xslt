<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:my="http://www.eigen.nl" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <xsl:output indent="no" omit-xml-declaration="yes" method="text" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- parameter tab bepaalt de inspringing in json, parameter level bepaalt de diepte -->
  <xsl:param name="tab"><xsl:text>  </xsl:text></xsl:param>

  <!-- parameters ten behoeve van url's -->
  <xsl:param name="delimiter" select="string('/')"/>
  <xsl:param name="organisatie" select="string('Geonovum')"/>

  <!-- document -->

  <xsl:template match="root()">
    <xsl:variable name="id" select="my:check_string((w:settings/w:docVars/w:docVar[@w:name='ID01']/@w:val,'geen')[1])"/>
    <xsl:variable name="respecConfig">
      <xsl:element name="item">
        <!-- ingevulde velden -->
        <xsl:if test="w:settings/w:docVars/w:docVar[@w:name='ID02']/@w:val">
          <xsl:element name="subtitle">
            <xsl:value-of select="w:settings/w:docVars/w:docVar[@w:name='ID02']/@w:val"/>
          </xsl:element>
        </xsl:if>
        <xsl:element name="pubDomain">
          <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID03']/@w:val,'Geen')[1]"/>
        </xsl:element>
        <xsl:element name="specStatus">
          <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID04']/@w:val,'Geen')[1]"/>
        </xsl:element>
        <xsl:element name="specType">
          <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID05']/@w:val,'Geen')[1]"/>
        </xsl:element>
        <xsl:element name="license">
          <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID06']/@w:val,'Geen')[1]"/>
        </xsl:element>
        <xsl:choose>
          <xsl:when test="w:settings/w:docVars/w:docVar[@w:name='ID04']/@w:val='GN-WV'">
            <!-- respec neemt de push-datum -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="publishDate">
              <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID07']/@w:val,fn:format-date(fn:current-date(),'[Y0001]-[M01]-[D01]'))[1]"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="w:settings/w:docVars/w:docVar[@w:name='ID08']/@w:val">
          <xsl:element name="previousPublishDate">
            <xsl:value-of select="w:settings/w:docVars/w:docVar[@w:name='ID08']/@w:val"/>
          </xsl:element>
          <xsl:element name="previousMaturity">
            <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID09']/@w:val,'Geen')[1]"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="number(w:settings/w:docVars/w:docVar[@w:name='ID10']/@w:val) gt 0">
          <xsl:element name="authors">
            <xsl:for-each select="for $index in 1 to w:settings/w:docVars/w:docVar[@w:name='ID10']/@w:val return w:settings/w:docVars/w:docVar[@w:name=concat('ID10',fn:format-number($index,'00'))]/@w:val">
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
        <xsl:if test="number(w:settings/w:docVars/w:docVar[@w:name='ID11']/@w:val) gt 0">
          <xsl:element name="editors">
            <xsl:for-each select="for $index in 1 to w:settings/w:docVars/w:docVar[@w:name='ID11']/@w:val return w:settings/w:docVars/w:docVar[@w:name=concat('ID11',fn:format-number($index,'00'))]/@w:val">
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
        <xsl:if test="number(w:settings/w:docVars/w:docVar[@w:name='ID12']/@w:val) gt 0">
          <xsl:element name="localBiblio">
            <xsl:for-each select="for $index in 1 to w:settings/w:docVars/w:docVar[@w:name='ID12']/@w:val return w:settings/w:docVars/w:docVar[@w:name=concat('ID12',fn:format-number($index,'00'))]/@w:val">
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
        <xsl:element name="github">
          <xsl:value-of select="fn:string-join(('https:','','github.com',$organisatie,fn:string-join(((w:settings/w:docVars/w:docVar[@w:name='ID03']/@w:val,'Geen')[1],$id),'-')),$delimiter)"/>
        </xsl:element>
        <xsl:element name="issueBase">
          <xsl:value-of select="fn:string-join(('https:','','github.com',$organisatie,fn:string-join(((w:settings/w:docVars/w:docVar[@w:name='ID03']/@w:val,'Geen')[1],$id),'-'),'issues'),$delimiter)"/>
        </xsl:element>
        <xsl:element name="edDraftURI">
          <xsl:value-of select="fn:string-join(('https:','',fn:string-join(($organisatie,'github','io'),'.'),fn:string-join(((w:settings/w:docVars/w:docVar[@w:name='ID03']/@w:val,'Geen')[1],$id),'-')),$delimiter)"/>
        </xsl:element>
      </xsl:element>
    </xsl:variable>
    <xsl:if test="$respecConfig/node()">
      <xsl:value-of select="string('var respecConfig =&#10;')"/>
      <xsl:apply-templates select="$respecConfig/node()">
        <xsl:with-param name="level" select="0"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="root|element()[child::item]" priority="10">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="indent" select="for $index in 1 to $level return $tab"/>
    <!-- element bevat een array -->
    <xsl:value-of select="fn:string-join(($indent,if (self::root|self::item) then '' else concat(name(),': '),'[&#10;'),'')"/>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="$level+1"/>
    </xsl:apply-templates>
    <xsl:value-of select="fn:string-join(($indent,']',if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
  </xsl:template>

  <xsl:template match="element()[child::element()]">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="indent" select="for $index in 1 to $level return $tab"/>
    <xsl:apply-templates select="@name">
      <xsl:with-param name="level" select="$level"/>
    </xsl:apply-templates>
    <xsl:value-of select="fn:string-join(($indent,if (self::root|self::item) then '' else concat(name(),': '),'{&#10;'),'')"/>
    <xsl:apply-templates select="node()">
      <xsl:with-param name="level" select="$level+1"/>
    </xsl:apply-templates>
    <xsl:value-of select="fn:string-join(($indent,'}',if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
  </xsl:template>

  <xsl:template match="element()[child::text()]">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="indent" select="for $index in 1 to $level return $tab"/>
    <xsl:value-of select="fn:string-join(($indent,if (self::root|self::item) then '' else concat(name(),': '),'&quot;'),'')"/>
    <xsl:copy-of select="text()"/>
    <xsl:value-of select="fn:string-join(('&quot;',if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="indent" select="for $index in 1 to $level return $tab"/>
    <xsl:value-of select="fn:string-join(($indent,'&quot;'),'')"/>
    <xsl:value-of select="."/>
    <xsl:value-of select="fn:string-join(('&quot;:&#10;'),'')"/>
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