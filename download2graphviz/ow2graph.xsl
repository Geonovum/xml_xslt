<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:owmanifest="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"
    xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" 
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" 
    xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand"
    xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" 
    xmlns:p="http://www.geostandaarden.nl/imow/pons" 
    xmlns:r="http://www.geostandaarden.nl/imow/regels" 
    xmlns:k="http://www.geostandaarden.nl/imow/kaart" 
    xmlns:ow="http://www.geostandaarden.nl/imow/owobject" 
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied"
    xmlns:op="http://www.geostandaarden.nl/imow/opobject"
    xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" 
    version="1.1">
<xsl:output method="text" indent="no"/>

<!-- documentroot -->
<xsl:template match="/ow-dc:owBestand">

<xsl:apply-templates select="//l:Gebiedengroep" />
<xsl:apply-templates select="//l:Gebied" />
<xsl:apply-templates select="//l:Ambtsgebied" />
<xsl:apply-templates select="//rol:Omgevingsnorm" />
<xsl:apply-templates select="//ga:Gebiedsaanwijzing" />
<!-- <xsl:apply-templates select="//r:ActiviteitLocatieaanduiding" /> -->

</xsl:template>

<xsl:template match="/owmanifest:Aanleveringen" />

<!--
<xsl:template match="rol:Normwaarde">
  "<xsl:value-of select="rol:identificatie"/>" 
</xsl:template>
-->

<xsl:template match="l:GebiedRef">
  "<xsl:value-of select="@xlink:href"/>" 
</xsl:template>

<xsl:template match="l:GeometrieRef">
  "<xsl:value-of select="@xlink:href"/>" 
</xsl:template>

<xsl:template match="l:LocatieRef">
  "<xsl:value-of select="@xlink:href"/>" 
</xsl:template>

<xsl:template match="l:Ambtsgebied">
/* begin ambtsgebied */
"<xsl:value-of select="l:identificatie"/>"[label="Ambtsgebied\n<xsl:value-of select="l:noemer"/>"]; 
/* end ambtsgebied */
</xsl:template>
 
<xsl:template match="ga:Gebiedsaanwijzing">
"<xsl:value-of
select="ga:identificatie"/>"[label="Gebiedsaanwijzing\n<xsl:value-of select="ga:naam"/>",color=red]; 
"<xsl:value-of select="ga:identificatie"/>" -> { <xsl:apply-templates select="ga:locatieaanduiding/l:LocatieRef"/> }[label=locatieref]
</xsl:template>

<xsl:template match="l:Gebiedengroep">
"<xsl:value-of select="l:identificatie"/>"[label="Gebiedengroep\n<xsl:value-of select="l:noemer"/>",color=red]; 
"<xsl:value-of select="l:identificatie"/>" -> { <xsl:apply-templates select="l:groepselement/l:GebiedRef"/> }[label=gebiedref]
</xsl:template>

<xsl:template match="rol:Omgevingsnorm">
"<xsl:value-of select="rol:identificatie"/>"[label="Omgevingsnorm\n<xsl:value-of select="rol:naam"/>"]; 
<xsl:apply-templates select="rol:normwaarde/rol:Normwaarde"/>
</xsl:template>

<xsl:template match="rol:Normwaarde">
"<xsl:value-of select="rol:identificatie"/>"[label="Normwaarde\n<xsl:value-of select="rol:kwantitatieveWaarde"/>"]; 
"<xsl:value-of select="rol:identificatie"/>" -> { <xsl:apply-templates select="rol:locatieaanduiding/l:LocatieRef"/> }[label=nwLocatie]
"<xsl:apply-templates select="../../rol:identificatie"/>" -> "<xsl:value-of select="rol:identificatie"/>"[label=normwaarde];
</xsl:template>

<xsl:template match="l:Lijn">
"<xsl:value-of select="l:identificatie"/>"[label="Lijn\n<xsl:value-of select="l:noemer"/>",color=red];
<!-- "<xsl:value-of select="l:identificatie"/>" -> { <xsl:apply-templates select="l:geometrie/l:GeometrieRef"/> }[label=geoRef] -->
</xsl:template>

<xsl:template match="l:Gebied">
"<xsl:value-of select="l:identificatie"/>"[label="Gebied\n<xsl:value-of select="l:noemer"/>",color=red];
<!-- "<xsl:value-of select="l:identificatie"/>" -> { <xsl:apply-templates select="l:geometrie/l:GeometrieRef"/> }[label=geoRef] -->
</xsl:template>

<xsl:template match="r:ActiviteitLocatieaanduiding">
"<xsl:value-of select="r:identificatie"/>"[label="ALA\n<xsl:value-of select="r:identificatie"/>",color=red];
"<xsl:value-of select="r:identificatie"/>" -> { <xsl:apply-templates select="r:locatieaanduiding"/> }[label=la]
</xsl:template>

</xsl:stylesheet>
