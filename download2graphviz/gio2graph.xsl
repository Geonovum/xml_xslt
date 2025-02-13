<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
    xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/"
    xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:se="http://www.opengis.net/se"
    xmlns:stop="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:uw="https://standaarden.overheid.nl/stop/imop/uitwisseling/"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    version="1.1">
<xsl:output method="text" indent="no"/>

<!--
Deze xslt converteert een xml document volgens de STOP informatieobject schema's
naar GraphViz statements.
-->

<!--
Er zijn twee manieren waarop de XML gestructureerd kan
   - In het formaat van een aanlevering. 
   - In het formaat met een pakbon
-->
<xsl:template match="/">
<xsl:apply-templates select="//stop:InformatieObjectVersie" />
<xsl:apply-templates select="//uw:Pakbon" />
</xsl:template>

<xsl:template match="stop:InformatieObjectVersie">
"<xsl:value-of
select="data:ExpressionIdentificatie/data:FRBRWork"/>"[label="GIO\n<xsl:value-of select="data:InformatieObjectMetadata/data:alternatieveTitels/data:alternatieveTitel"/>",color=blue,shape=oval; 
"<xsl:value-of select="data:ExpressionIdentificatie/data:FRBRWork"/>" -> { "<xsl:apply-templates select="gio:JuridischeBorgingVan/gio:Object/gio:domeinObjectID"/>" }[label=borging]
</xsl:template>

<!-- We willen graag alle GIO's uit een pakbon halen. Deze zijn te herkennan aan soortWork  = 010 en dat ze een moduel GeoInformatieObjectVersie hebben -->
<xsl:template match="uw:Pakbon">
<xsl:apply-templates select="uw:Component[./uw:soortWork='/join/id/stop/work_010' and ./uw:heeftModule/uw:Module/uw:localName='GeoInformatieObjectVersie']" />
</xsl:template>

<xsl:template match="uw:Component">
"<xsl:value-of select="uw:FRBRWork"/>"[label="GIO\n<xsl:value-of select="document(uw:heeftModule/uw:Module[./uw:localName='InformatieObjectMetadata']/uw:bestandsnaam)/data:InformatieObjectMetadata/data:naamInformatieObject" />",color=blue,shape=oval];
"<xsl:value-of select="uw:FRBRWork"/>" -> "<xsl:value-of select="document(uw:heeftModule/uw:Module[./uw:localName='JuridischeBorgingVan']/uw:bestandsnaam)/gio:JuridischeBorgingVan/gio:Object/gio:domeinObjectID" />"[label="borging van"]
<xsl:apply-templates select="document(uw:heeftModule/uw:Module[./uw:localName='GeoInformatieObjectVersie']/uw:bestandsnaam)/geo:GeoInformatieObjectVersie" />

<!--
"<xsl:value-of select="uw:FRBRWork"/>" -> { "<xsl:value-of select="document(uw:heeftModule/uw:Module[./uw:localName='GeoInformatieObjectVersie']/uw:bestandsnaam)/geo:GeoInformatieObjectVersie/geo:locaties/geo:Locatie/geo:geometrie/basisgeo:id" />"[label="giolocs"] }
-->

</xsl:template>
<xsl:template match="geo:Groep">
"<xsl:value-of select="../../geo:FRBRWork"/>" -> { "<xsl:value-of select="geo:groepID"/>" }[label=GIOgroep,color=blue,shape=oval]
</xsl:template>

<xsl:template match="geo:GeoInformatieObjectVersie">
<xsl:apply-templates select="geo:groepen/geo:Groep"/>
</xsl:template>

</xsl:stylesheet>
