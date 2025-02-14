<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:my="http://www.eigen.nl" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- de configuratie is specifiek voor organisatie Geonovum -->

  <!-- parameters ten behoeve van url's -->
  <xsl:param name="delimiter" select="string('/')"/>

  <!-- options -->
  <xsl:param name="options" select="document('options.xml')/respec"/>

  <!-- parameters workflow -->
  <xsl:param name="workflow_company_name" select="string('Geonovum')"/>
  <xsl:param name="workflow_company_url" select="string('https://www.geonovum.nl')"/>
  <xsl:param name="workflow_company_docs" select="string('https://docs.geostandaarden.nl')"/>
  <xsl:param name="workflow_company_tools" select="string('https://tools.geostandaarden.nl')"/>

  <!-- parameters respec -->
  <xsl:param name="respec_subtitle" select="w:settings/w:docVars/w:docVar[@w:name='ID002']/@w:val"/>
  <xsl:param name="respec_shortName" select="(w:settings/w:docVars/w:docVar[@w:name='ID003']/@w:val,my:check_string(w:settings/w:docVars/w:docVar[@w:name='ID001']/@w:val),'Geen')[1]"/>
  <xsl:param name="respec_pubDomain" select="(w:settings/w:docVars/w:docVar[@w:name='ID004']/@w:val,'Geen')[1]"/>
  <xsl:param name="respec_specStatus" select="(w:settings/w:docVars/w:docVar[@w:name='ID005']/@w:val,'Geen')[1]"/>
  <xsl:param name="respec_specType" select="(w:settings/w:docVars/w:docVar[@w:name='ID006']/@w:val,'Geen')[1]"/>
  <xsl:param name="respec_license" select="(w:settings/w:docVars/w:docVar[@w:name='ID007']/@w:val,'Geen')[1]"/>
  <xsl:param name="respec_publishDate">
    <xsl:choose>
      <xsl:when test="$respec_specStatus='GN-WV'">
        <!-- respec neemt de push-datum (current-date) -->
        <xsl:value-of select="fn:format-date(fn:current-date(),'[Y0001]-[M01]-[D01]','nl','AD','nl')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="fn:format-date((w:settings/w:docVars/w:docVar[@w:name='ID008']/@w:val,fn:current-date())[1],'[Y0001]-[M01]-[D01]','nl','AD','nl')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="respec_previousPublishDate" select="w:settings/w:docVars/w:docVar[@w:name='ID009']/@w:val"/>
  <xsl:param name="respec_previousMaturity" select="(w:settings/w:docVars/w:docVar[@w:name='ID010']/@w:val,'Geen')[1]"/>
  <xsl:param name="respec_github" select="my:url(('https:','','github.com',$workflow_company_name,fn:string-join(($respec_pubDomain,$respec_shortName),'-')))"/>
  <xsl:param name="respec_issueBase" select="my:url(('https:','','github.com',$workflow_company_name,fn:string-join(($respec_pubDomain,$respec_shortName),'-'),'issues'))"/>
  <xsl:param name="respec_edDraftURI" select="my:url(('https:','',fn:string-join(($workflow_company_name,'github','io'),'.'),fn:string-join(($respec_pubDomain,$respec_shortName),'-')))"/>

  <!-- document -->

  <xsl:template match="root()">
    <xsl:element name="config">
      <!-- respec -->
      <xsl:element name="item">
        <xsl:comment>respec</xsl:comment>
        <!-- ingevulde velden -->
        <xsl:element name="pubDomain">
          <xsl:value-of select="$respec_pubDomain"/>
        </xsl:element>
        <xsl:element name="specStatus">
          <xsl:value-of select="$respec_specStatus"/>
        </xsl:element>
        <xsl:element name="specType">
          <xsl:value-of select="$respec_specType"/>
        </xsl:element>
        <xsl:element name="license">
          <xsl:value-of select="$respec_license"/>
        </xsl:element>
        <xsl:element name="publishDate">
          <xsl:value-of select="$respec_publishDate"/>
        </xsl:element>
        <xsl:if test="normalize-space($respec_previousPublishDate) ne ''">
          <xsl:element name="previousPublishDate">
            <xsl:value-of select="$respec_previousPublishDate"/>
          </xsl:element>
          <xsl:element name="previousMaturity">
            <xsl:value-of select="$respec_previousMaturity"/>
          </xsl:element>
        </xsl:if>
        <xsl:element name="authors">
          <xsl:element name="item">
            <xsl:element name="name">
              <xsl:value-of select="string('TPOD-Team')"/>
            </xsl:element>
            <xsl:element name="company">
              <xsl:value-of select="string('Geonovum')"/>
            </xsl:element>
            <xsl:element name="companyURL">
              <xsl:value-of select="my:url('https://www.geonovum.nl')"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <xsl:element name="editors">
          <xsl:element name="item">
            <xsl:element name="name">
              <xsl:value-of select="string('TPOD-Team')"/>
            </xsl:element>
            <xsl:element name="company">
              <xsl:value-of select="string('Geonovum')"/>
            </xsl:element>
            <xsl:element name="companyURL">
              <xsl:value-of select="my:url('https://www.geonovum.nl')"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <xsl:if test="number(w:settings/w:docVars/w:docVar[@w:name='ID012']/@w:val) gt 0">
          <xsl:element name="localBiblio">
            <xsl:for-each select="for $index in 1 to w:settings/w:docVars/w:docVar[@w:name='ID012']/@w:val return w:settings/w:docVars/w:docVar[@w:name=concat('ID012',fn:format-number($index,'00'))]/@w:val">
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
          <xsl:value-of select="$respec_shortName"/>
        </xsl:element>
        <xsl:element name="format">
          <xsl:value-of select="string('markdown')"/>
        </xsl:element>
        <xsl:if test="w:settings/w:docVars/w:docVar[@w:name='ID011']/@w:val = ('Waar','True')">
          <xsl:element name="github">
            <xsl:value-of select="$respec_github"/>
          </xsl:element>
          <xsl:element name="issueBase">
            <xsl:value-of select="$respec_issueBase"/>
          </xsl:element>
        </xsl:if>
        <xsl:element name="edDraftURI">
          <xsl:value-of select="$respec_edDraftURI"/>
        </xsl:element>
        <xsl:choose>
          <xsl:when test="$respec_specStatus='GN-WV'">
            <!-- respec neemt de push-datum -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="publishISODate">
              <xsl:value-of select="concat(fn:format-date($respec_publishDate,'[Y0001]-[M01]-[D01]','nl','AD','nl'),'T00:00:00.000Z')"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="generatedSubtitle">
          <xsl:choose>
            <xsl:when test="$respec_pubDomain=('ow','tpod')">
              <xsl:value-of select="string('STandaard Officiële Publicaties met ToepassingsProfielen voor OmgevingsDocumenten (STOP/TPOD)')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:element>
      </xsl:element>
      <!-- workflow -->
      <xsl:element name="item">
        <xsl:comment>workflow</xsl:comment>
        <xsl:element name="company">
          <xsl:element name="name">
            <xsl:value-of select="$workflow_company_name"/>
          </xsl:element>
          <xsl:element name="url">
            <xsl:value-of select="my:url($workflow_company_url)"/>
          </xsl:element>
          <xsl:element name="docs">
            <xsl:value-of select="my:url($workflow_company_docs)"/>
          </xsl:element>
          <xsl:element name="tools">
            <xsl:value-of select="my:url($workflow_company_tools)"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="document">
          <xsl:element name="title">
            <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID001']/@w:val,'Geen')[1]"/>
          </xsl:element>
          <xsl:element name="version">
            <xsl:value-of select="(w:settings/w:docVars/w:docVar[@w:name='ID002']/@w:val,'Geen')[1]"/>
          </xsl:element>
          <xsl:element name="currentVersion">
            <xsl:choose>
              <xsl:when test="$respec_specStatus='GN-WV'">
                <xsl:value-of select="$respec_edDraftURI"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="my:url(($workflow_company_docs,$respec_pubDomain,fn:string-join((lower-case(fn:substring-after($respec_specStatus,'GN-')),lower-case($respec_specType),$respec_shortName,fn:format-date($respec_publishDate,'[Y0001][M01][D01]','nl','AD','nl')),'-')))"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <xsl:element name="lastPublishedVersion">
            <xsl:value-of select="my:url(($workflow_company_docs,$respec_pubDomain,$respec_shortName))"/>
          </xsl:element>
          <xsl:if test="$respec_previousPublishDate">
            <xsl:element name="lastVersion">
              <xsl:value-of select="my:url(($workflow_company_docs,$respec_pubDomain,fn:string-join((lower-case(fn:substring-after($respec_previousMaturity,'GN-')),lower-case($respec_specType),$respec_shortName,fn:format-date($respec_previousPublishDate,'[Y0001][M01][D01]','nl','AD','nl')),'-')))"/>
            </xsl:element>
          </xsl:if>
        </xsl:element>
        <xsl:element name="domain">
          <xsl:comment> Deze informatie moet straks uit configuratie op basis van pubDomain kommen. Denk aan zaken als 'samenvatting j/n', 'sotd j/n', 'niveau inhoudsopgave' etc.</xsl:comment>
          <xsl:element name="name">
            <xsl:value-of select="$respec_pubDomain"/>
          </xsl:element>
          <xsl:element name="contact">
            <xsl:value-of select="string('omgevingswet@geonovum.nl')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="github">
          <xsl:element name="organization">
            <xsl:value-of select="$workflow_company_name"/>
          </xsl:element>
          <xsl:element name="repository">
            <xsl:value-of select="fn:string-join(($respec_pubDomain,$respec_shortName),'-')"/>
          </xsl:element>
          <xsl:element name="url">
            <xsl:value-of select="$respec_github"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="ftp">
          <xsl:element name="server">
            <xsl:value-of select="if (w:settings/w:docVars/w:docVar[@w:name='ID013']/@w:val = ('Waar','True')) then 'docs.geostandaarden.nl' else 'test.docs.geostandaarden.nl'"/>
          </xsl:element>
          <xsl:element name="username">
            <xsl:value-of select="if (w:settings/w:docVars/w:docVar[@w:name='ID013']/@w:val = ('Waar','True')) then 'documenten' else 'documenten-test'"/>
          </xsl:element>
          <xsl:element name="currentVersion">
            <xsl:value-of select="my:url(('.',$respec_pubDomain,fn:string-join((lower-case(fn:substring-after($respec_specStatus,'GN-')),lower-case($respec_specType),$respec_shortName,fn:format-date($respec_publishDate,'[Y0001][M01][D01]','nl','AD','nl')),'-')))"/>
          </xsl:element>
          <xsl:element name="lastPublishedVersion">
            <xsl:value-of select="my:url(('.',$respec_pubDomain,$respec_shortName))"/>
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

  <!-- functies -->

  <!-- functie om url's te uniformeren -->
  <!-- parameter url is een string of sequence of string -->
  <xsl:function name="my:url">
    <xsl:param name="url"/>
    <xsl:variable name="list" as="xs:string*">
      <xsl:for-each select="$url">
        <xsl:for-each select="fn:tokenize(.,$delimiter)[. ne '']">
          <xsl:value-of select="."/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="fn:ends-with($list[1],':')">
        <!-- absoluut -->
        <xsl:choose>
          <xsl:when test="matches(fn:subsequence($list,3)[last()],'.+[\.][a-zA-Z]+[a-zA-Z0-9]+')">
            <!-- bestand -->
            <xsl:value-of select="fn:string-join(($list[1],'',fn:subsequence($list,2)),$delimiter)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- map -->
            <xsl:value-of select="fn:string-join(($list[1],'',fn:subsequence($list,2),''),$delimiter)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- relatief -->
        <xsl:choose>
          <xsl:when test="matches($list[last()],'.+[\.][a-zA-Z]+[a-zA-Z0-9]+')">
            <!-- bestand -->
            <xsl:value-of select="fn:string-join($list,$delimiter)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- map -->
            <xsl:value-of select="fn:string-join(($list,''),$delimiter)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>