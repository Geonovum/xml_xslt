<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
  <xsl:output method="text" encoding="utf-8"/>

  <xsl:param name="base.dir" select="fn:tokenize(fn:base-uri(.),'input')[1]"/>
  <xsl:param name="input.dir" select="concat($base.dir,'input/')"/>
  <xsl:param name="output.dir" select="concat($base.dir,'output/')"/>

  <!-- bestanden -->
  <xsl:param name="regeling_tekst" select="document(concat($input.dir,'Regeling/Regeling-Tekst.xml'))/element()"/>

  <!-- informatieobjectrefs -->
  <xsl:param name="informatieobjectRefs" select="$regeling_tekst//tekst:ExtIoRef/@ref" as="xs:token*"/>

  <!-- bouw de op-bestanden op -->

  <xsl:template match="/">
    <xsl:variable name="https" select="string('https://identifier-eto.officielebekendmakingen.nl')"/>
    <xsl:element name="informatieobjectRefs">
      <xsl:for-each select="$informatieobjectRefs">
        <xsl:value-of select="concat($https,.,'&#10;')"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>