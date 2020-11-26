<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:my="http://www.eigen.nl">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- transformatie voert mutaties door -->

  <xsl:param name="waardelijsten">
    <!-- waardelijsten bevat een platte weergave van de waardelijsten -->
    <xsl:for-each select="document('waardelijsten 1.0.5.xml')//element()[ancestor::waardelijst][not(descendant::element())]">
      <xsl:element name="{name()}">
        <xsl:attribute name="path" select="fn:string-join((ancestor::waardelijst/titel,(parent::domein,parent::waarde)[1]/term,(parent::domein,parent::waarde)[1]/label),'/')"/>
        <xsl:attribute name="context" select="(parent::domein,parent::waarde,parent::waardelijst)[1]/name()"/>
        <xsl:copy-of select="@*|text()"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <xsl:param name="mutatie">
    <!-- mutatie bevat een platte weergave van de mutaties -->
    <xsl:for-each select="//waarde">
      <xsl:variable name="waardelijst" select="ancestor::waardelijst/titel"/>
      <xsl:variable name="term" select="my:check_string(lower-case(./label))"/>
      <xsl:variable name="label" select="tokenize(lower-case(./label),'_')[last()]"/>
      <xsl:variable name="path" select="fn:string-join(($waardelijst,$term,$label),'/')"/>
      <xsl:variable name="domein">
        <xsl:choose>
          <xsl:when test="$waardelijst='Activiteitengroep'">
            <xsl:value-of select="string('Activiteit')"/>
          </xsl:when>
          <xsl:when test="ends-with($waardelijst,'groep')">
            <xsl:value-of select="my:check_string(replace($waardelijst,'groep',''))"/>
          </xsl:when>
          <xsl:when test="$waardelijst='Thema'">
            <!-- let op: label is een combinatie tussen [hoofdthema]_[subthema] -->
            <xsl:value-of select="my:check_string(tokenize(./label,'_')[1])"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="my:check_string($waardelijst)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="label">
        <xsl:attribute name="path" select="$path"/>
        <xsl:attribute name="context" select="string('waarde')"/>
        <xsl:value-of select="$label"/>
      </xsl:element>
      <xsl:element name="term">
        <xsl:attribute name="path" select="$path"/>
        <xsl:attribute name="context" select="string('waarde')"/>
        <xsl:value-of select="$term"/>
      </xsl:element>
      <xsl:element name="uri">
        <xsl:attribute name="path" select="$path"/>
        <xsl:attribute name="context" select="string('waarde')"/>
        <xsl:value-of select="concat('http://standaarden.omgevingswet.overheid.nl/',lower-case($domein),'/id/concept/',$term)"/>
      </xsl:element>
      <xsl:element name="definitie">
        <xsl:attribute name="path" select="$path"/>
        <xsl:attribute name="context" select="string('waarde')"/>
        <xsl:value-of select="normalize-space(./definitie)"/>
      </xsl:element>
      <xsl:element name="toelichting">
        <xsl:attribute name="path" select="$path"/>
        <xsl:attribute name="context" select="string('waarde')"/>
        <xsl:value-of select="normalize-space(./toelichting)"/>
      </xsl:element>
      <xsl:element name="bron">
        <xsl:attribute name="path" select="$path"/>
        <xsl:attribute name="context" select="string('waarde')"/>
        <xsl:value-of select="normalize-space(./bron)"/>
      </xsl:element>
      <xsl:element name="domein">
        <xsl:attribute name="path" select="$path"/>
        <xsl:attribute name="context" select="string('waarde')"/>
        <xsl:value-of select="concat('http://standaarden.omgevingswet.overheid.nl/id/conceptscheme/',$domein)"/>
      </xsl:element>
      <xsl:element name="specialisatie">
        <xsl:attribute name="path" select="$path"/>
        <xsl:attribute name="context" select="string('waarde')"/>
        <xsl:if test="($waardelijst='Thema') and not($domein=$term)">
          <xsl:value-of select="concat('http://standaarden.omgevingswet.overheid.nl/',lower-case($domein),'/id/concept/',$domein)"/>
        </xsl:if>
      </xsl:element>
      <xsl:element name="symboolcode">
        <xsl:attribute name="path" select="$path"/>
        <xsl:attribute name="context" select="string('waarde')"/>
        <xsl:attribute name="id" select="normalize-space(./symboolcode)"/>
        <xsl:value-of select="normalize-space(./symboolcode)"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <xsl:variable name="nieuw">
    <xsl:for-each select="$waardelijsten/element()">
      <xsl:variable name="id" select="@path"/>
      <xsl:variable name="context" select="@context"/>
      <xsl:variable name="name" select="name()"/>
      <!-- als een bestaande waarde voorkomt in mutatie, dan deze overnemen -->
      <xsl:copy-of select="($mutatie/element()[@path=$id][@context=$context][name()=$name][. ne ''],.)[1]"/>
    </xsl:for-each>
    <xsl:for-each select="$mutatie/element()">
      <xsl:variable name="id" select="@path"/>
      <xsl:variable name="name" select="name()"/>
      <!-- als een mutatie niet voorkomt in bestaande waarden, dan deze toevoegen -->
      <xsl:if test="not($waardelijsten/element()[@path=$id][@context='waarde'][name()=$name])">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>
    <!-- hier zou nog een check moeten of er bij thema een nieuw domein toegevoegd moet worden -->
  </xsl:variable>

  <xsl:template match="waardelijsten">
    <xsl:element name="waardelijsten">
      <xsl:element name="versie">
        <xsl:value-of select="versie"/>
      </xsl:element>
      <xsl:for-each-group select="$nieuw/element()" group-by="tokenize(@path,'/')[1]">
        <xsl:sort select="current-grouping-key()"/>
        <xsl:element name="waardelijst">
          <xsl:for-each select="current-group()[@context='waardelijst']">
            <xsl:element name="{name()}">
              <xsl:copy-of select="@id|text()"/>
            </xsl:element>
          </xsl:for-each>
          <xsl:element name="waarden">
            <xsl:for-each-group select="current-group()[@context='waarde']" group-by="tokenize(@path,'/')[2]">
              <xsl:sort select="current-grouping-key()"/>
              <xsl:element name="waarde">
                <xsl:for-each select="current-group()">
                  <xsl:element name="{name()}">
                    <xsl:copy-of select="@id|text()"/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:for-each-group>
          </xsl:element>
          <xsl:element name="domeinen">
            <xsl:for-each-group select="current-group()[@context='domein']" group-by="tokenize(@path,'/')[2]">
              <xsl:sort select="current-grouping-key()"/>
              <xsl:element name="domein">
                <xsl:for-each select="current-group()">
                  <xsl:element name="{name()}">
                    <xsl:copy-of select="@id|text()"/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:for-each-group>
          </xsl:element>
        </xsl:element>
      </xsl:for-each-group>
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

  <!-- algemene templates -->

  <xsl:template match="element()">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>


</xsl:stylesheet>