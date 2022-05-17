<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:digest="java:org.apache.commons.codec.digest.DigestUtils" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:l="http://www.geostandaarden.nl/imow/locatie">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <!-- de transformatie zet een downloadpakketje om naar publicatie van een initieel besluit -->

  <xsl:param name="base.dir" select="fn:tokenize(fn:base-uri(.),'input')[1]"/>
  <xsl:param name="input.dir" select="concat($base.dir,'input/')"/>
  <xsl:param name="temp.dir" select="concat($base.dir,'temp/')"/>
  <xsl:param name="output.dir" select="concat($base.dir,'output/')"/>

  <!-- guids -->

  <xsl:param name="guids">
    <xsl:element name="ow">
      <xsl:for-each select="collection(concat($input.dir,'OW-bestanden','?select=*.gml'))">
        <xsl:variable name="document" select="fn:tokenize(document-uri(.),'/')[last()]"/>
        <xsl:for-each select=".//basisgeo:Geometrie">
          <xsl:variable name="geometrie" select="."/>
          <xsl:variable name="content" as="xs:token*">
            <xsl:for-each select="fn:tokenize(fn:string-join($geometrie//gml:posList/text(),' '),'\s+')">
              <xsl:sort/>
              <xsl:value-of select="number(.)"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="guid">
            <xsl:element name="id">
              <xsl:value-of select="$geometrie/basisgeo:id"/>
            </xsl:element>
            <xsl:element name="content">
              <xsl:value-of select="digest:md5Hex(fn:string-join($content, ''))"/>
            </xsl:element>
            <xsl:element name="document">
              <xsl:value-of select="$document"/>
            </xsl:element>
            <xsl:for-each select="collection(concat($input.dir,'OW-bestanden','?select=*.xml'))//(l:Gebied[descendant::element()/@xlink:href=$geometrie/basisgeo:id],l:Ambtsgebied[descendant::l:bestuurlijkeGrenzenID=$geometrie/basisgeo:id])">
              <xsl:element name="noemer">
                <xsl:value-of select="./l:noemer"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="op">
      <xsl:for-each select="collection(concat($temp.dir,'?select=*.gml',';recurse=yes'))">
        <xsl:variable name="document" select="fn:tokenize(document-uri(.),'/')[last()]"/>
        <xsl:for-each select=".//basisgeo:Geometrie">
          <xsl:variable name="geometrie" select="."/>
          <xsl:variable name="content" as="xs:token*">
            <xsl:for-each select="fn:tokenize(fn:string-join($geometrie//gml:posList/text(),' '),'\s+')">
              <xsl:sort/>
              <xsl:value-of select="number(.)"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="guid">
            <xsl:element name="id">
              <xsl:value-of select="$geometrie/basisgeo:id"/>
            </xsl:element>
            <xsl:element name="content">
              <xsl:value-of select="digest:md5Hex(fn:string-join($content, ''))"/>
            </xsl:element>
            <xsl:element name="document">
              <xsl:value-of select="$document"/>
            </xsl:element>
            <xsl:for-each select="collection(concat($temp.dir,'gml','?select=',$document))//geo:Locatie[descendant::basisgeo:id=$geometrie/basisgeo:id]">
              <xsl:element name="noemer">
                <xsl:value-of select="./geo:naam"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>    
    </xsl:element>
  </xsl:param>

  <xsl:param name="refs">
    <xsl:for-each select="fn:distinct-values(collection(concat($input.dir,'OW-bestanden','?select=gebieden.xml'))//element()/@xlink:href)">
      <xsl:element name="ref">
        <xsl:attribute name="index" select="position()"/>
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- bouw het bestand op -->

  <xsl:template match="/">
    <xsl:element name="test">
      <xsl:comment><xsl:text>elk ref in gebieden.xml, met een verwijzing naar de documenten in OP en OW waarin die voorkomt.</xsl:text></xsl:comment>
      <xsl:element name="refs">
        <xsl:for-each select="$refs/ref">
          <xsl:variable name="ref" select="."/>
          <xsl:element name="ref">
            <xsl:attribute name="index" select="position()"/>
            <xsl:attribute name="id" select="$ref"/>
            <xsl:for-each select="$guids//guid[./id=$ref]">
              <xsl:element name="document">
                <xsl:attribute name="type" select="./(ancestor::op|ancestor::ow)/name()"/>
                <xsl:value-of select="./document"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      <xsl:comment><xsl:text>elke noemer, met een verwijzing naar de documenten in OP en OW met een overeenkomstige noemer</xsl:text></xsl:comment>
      <xsl:element name="noemers">
        <xsl:for-each-group select="$guids//guid" group-by="noemer">
          <xsl:element name="noemer">
            <xsl:attribute name="index" select="position()"/>
            <xsl:attribute name="waarde" select="current-grouping-key()"/>
            <xsl:for-each select="current-group()/self::guid">
              <xsl:element name="document">
                <xsl:attribute name="type" select="./(ancestor::op|ancestor::ow)/name()"/>
                <xsl:value-of select="./document"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each-group>
      </xsl:element>
      <xsl:comment><xsl:text>elke content bevat de hash van de onderliggende posList, met een verwijzing naar de documenten in OP en OW waarvan de hash van de onderliggende posList overeenkomt</xsl:text></xsl:comment>
      <xsl:element name="contents">
        <xsl:for-each select="fn:distinct-values($guids//content)">
          <xsl:variable name="content" select="."/>
          <xsl:element name="content">
            <xsl:attribute name="index" select="position()"/>
            <xsl:attribute name="hash" select="."/>
            <xsl:for-each select="$guids//guid[./content=$content]">
              <xsl:element name="document">
                <xsl:attribute name="type" select="./(ancestor::op|ancestor::ow)/name()"/>
                <xsl:attribute name="id" select="./id"/>
                <xsl:value-of select="./document"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      <xsl:comment><xsl:text>guids</xsl:text></xsl:comment>
      <xsl:element name="guids">
        <xsl:for-each select="$guids//guid">
          <xsl:element name="guid">
            <xsl:attribute name="index" select="count(.|preceding-sibling::guid)"/>
            <xsl:attribute name="type" select="./(ancestor::op|ancestor::ow)/name()"/>
            <xsl:copy-of select="@*|element()"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>