<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:apply-templates select="//Table"/>
  </xsl:template>
  
  <xsl:template match="Table">
    <xsl:element name="waardelijsten">
      <xsl:element name="versie">
        <xsl:value-of select="string('1.0.2')"/>
      </xsl:element>
      <xsl:for-each-group select="Row" group-starting-with="Row[Cell[1][not(@ss:Index)]/Data]">
        <xsl:variable name="Row">
          <xsl:call-template name="check_row">
            <xsl:with-param name="current" select="current-group()[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="string" select="tokenize(replace($Row/Cell[@index=1]/Data,'Waardelijst',''),('\[|\]'))"/>
        <xsl:variable name="naam" select="normalize-space($string[1])"/>
        <xsl:variable name="type" select="normalize-space($string[2])"/>
        <xsl:choose>
          <xsl:when test="not($naam='')">
            <xsl:element name="waardelijst">
              <xsl:element name="label">
                <xsl:value-of select="lower-case($naam)"/>
              </xsl:element>
              <xsl:element name="titel">
                <xsl:call-template name="check_string">
                  <xsl:with-param name="string" select="$naam"/>
                </xsl:call-template>
              </xsl:element>
              <xsl:element name="uri">
                <xsl:variable name="term">
                  <xsl:call-template name="check_string">
                    <xsl:with-param name="string" select="$naam"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('http://standaarden.omgevingswet.overheid.nl/id/waardelijst/',$term)"/>
              </xsl:element>
              <xsl:element name="type">
                <xsl:choose>
                  <xsl:when test="$type">
                    <xsl:value-of select="$type"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="string('uitbreidbaar')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
              <xsl:element name="omschrijving">
                <xsl:value-of select="normalize-space(string-join($Row/Cell[@index=4]/Data/node(),''))"/>
              </xsl:element>
              <xsl:element name="toelichting">
                <xsl:value-of select="normalize-space(string-join($Row/Cell[@index=3]/Data/node(),''))"/>
              </xsl:element>
              <xsl:element name="waarden">
                <xsl:for-each select="fn:subsequence(current-group(),2)">
                  <xsl:apply-templates select="self::Row[Cell/Data]" mode="waarde">
                    <xsl:with-param name="waardelijst" select="$naam"/>
                  </xsl:apply-templates>
                </xsl:for-each>
              </xsl:element>
              <xsl:element name="domeinen">
                <xsl:choose>
                  <xsl:when test="$naam='Thema'">
                    <xsl:for-each-group select="fn:subsequence(current-group(),2)/self::Row[Cell/Data]" group-starting-with="self::Row[not(contains(Cell[@ss:Index=2]/Data,' - '))]">
                      <xsl:apply-templates select="current-group()[1]" mode="domein">
                        <xsl:with-param name="waardelijst" select="$naam"/>
                      </xsl:apply-templates>
                    </xsl:for-each-group>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="current-group()[1]" mode="domein">
                      <xsl:with-param name="waardelijst" select="$naam"/>
                    </xsl:apply-templates>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Row" mode="waarde">
    <xsl:param name="waardelijst"/>
    <xsl:variable name="Row">
      <xsl:call-template name="check_row">
        <xsl:with-param name="current" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:element name="waarde">
      <xsl:variable name="naam" select="normalize-space(replace(string-join($Row/Cell[@index=2]/Data/node(),''),' - ','_'))"/>
      <xsl:variable name="term">
        <xsl:call-template name="check_string">
          <xsl:with-param name="string" select="$naam"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="domein">
        <xsl:choose>
          <xsl:when test="$waardelijst='Activiteitengroep'">
            <xsl:value-of select="string('Activiteit')"/>
          </xsl:when>
          <xsl:when test="ends-with($waardelijst,'groep')">
            <xsl:call-template name="check_string">
              <xsl:with-param name="string" select="replace($waardelijst,'groep','')"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$waardelijst='Thema'">
            <xsl:call-template name="check_string">
              <xsl:with-param name="string" select="tokenize($naam,'_')[1]"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="check_string">
              <xsl:with-param name="string" select="$waardelijst"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="label">
        <xsl:value-of select="lower-case(tokenize($naam,'_')[last()])"/>
      </xsl:element>
      <xsl:element name="term">
        <xsl:value-of select="$term"/>
      </xsl:element>
      <xsl:element name="uri">
        <xsl:value-of select="concat('http://standaarden.omgevingswet.overheid.nl/',lower-case($domein),'/id/concept/',$term)"/>
      </xsl:element>
      <xsl:element name="definitie">
        <xsl:value-of select="normalize-space(string-join($Row/Cell[@index=4]/Data/node(),''))"/>
      </xsl:element>
      <xsl:element name="toelichting">
        <xsl:value-of select="normalize-space(string-join($Row/Cell[@index=3]/Data/node(),''))"/>
      </xsl:element>
      <xsl:element name="bron">
        <xsl:value-of select="normalize-space(string-join($Row/Cell[@index=5]/Data/node(),''))"/>
      </xsl:element>
      <xsl:element name="domein">
        <xsl:value-of select="concat('http://standaarden.omgevingswet.overheid.nl/id/conceptscheme/',$domein)"/>
      </xsl:element>
      <xsl:element name="specialisatie">
        <xsl:if test="($waardelijst='Thema') and not($domein=$term)">
          <xsl:value-of select="concat('http://standaarden.omgevingswet.overheid.nl/',lower-case($domein),'/id/concept/',$domein)"/>
        </xsl:if>
      </xsl:element>
      <xsl:element name="symboolcode">
        <xsl:value-of select="normalize-space(string-join($Row/Cell[@index=8]/Data/node(),''))"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Row" mode="domein">
    <xsl:param name="waardelijst"/>
    <xsl:variable name="Row">
      <xsl:call-template name="check_row">
        <xsl:with-param name="current" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:element name="domein">
      <xsl:variable name="naam">
        <xsl:choose>
          <xsl:when test="$waardelijst='Activiteitengroep'">
            <xsl:value-of select="string('Activiteit')"/>
          </xsl:when>
          <xsl:when test="ends-with($waardelijst,'groep')">
            <xsl:value-of select="replace($waardelijst,'groep','')"/>
          </xsl:when>
          <xsl:when test="$waardelijst='Thema'">
            <xsl:value-of select="$Row/Cell[@index=2]/Data"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$waardelijst"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="term">
        <xsl:call-template name="check_string">
          <xsl:with-param name="string" select="$naam"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:element name="label">
        <xsl:value-of select="lower-case(tokenize($naam,'_')[last()])"/>
      </xsl:element>
      <xsl:element name="term">
        <xsl:value-of select="$term"/>
      </xsl:element>
      <xsl:element name="uri">
        <xsl:value-of select="concat('http://standaarden.omgevingswet.overheid.nl/id/conceptscheme/',$term)"/>
      </xsl:element>
      <xsl:element name="omschrijving">
        <xsl:value-of select="normalize-space(string-join($Row/Cell[@index=4]/Data/node(),''))"/>
      </xsl:element>
      <xsl:element name="toelichting">
        <xsl:value-of select="normalize-space(string-join($Row/Cell[@index=3]/Data/node(),''))"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- routines -->

  <xsl:template name="check_string">
    <xsl:param name="string"/>
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
  </xsl:template>

  <xsl:template name="check_row">
    <xsl:param name="current"/>
    <xsl:for-each-group select="Cell" group-starting-with="Cell[@ss:Index]">
      <xsl:variable name="index" select="number((current-group()[1]/@ss:Index,'1')[1])"/>
      <xsl:variable name="test_0" select="current-group()"/>
      <xsl:for-each select="current-group()">
        <xsl:variable name="positie" select="position()-1"/>
        <xsl:element name="Cell">
          <xsl:attribute name="index" select="$index+$positie"/>
          <xsl:copy-of select="Data"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:template>

</xsl:stylesheet>