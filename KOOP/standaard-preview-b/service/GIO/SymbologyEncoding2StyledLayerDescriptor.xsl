<?xml version="1.0"?>
<!--
     XSLT die een SE bestand, dat aan de STOP standaard voldoet converteert naar een SLD
     bestand dat bijvoorbeeld door QGIS gebruikt kan worden.

     Wilko Quak (wilko.quak@koop.overheid.nl)
-->
<xsl:stylesheet version="2.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0" />

    <xsl:template match="/">
    <sld:StyledLayerDescriptor xmlns:sld="http://www.opengis.net/sld" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:se="http://www.opengis.net/se" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ogc="http://www.opengis.net/ogc" version="1.1.0" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd">
    	  <sld:NamedLayer>
    	    <se:Name>SLD gegenereerd met xslt</se:Name>
    	    <sld:UserStyle>
    	      <se:Name>Locaties</se:Name>
                <xsl:copy-of select="." />
    	    </sld:UserStyle>
    	  </sld:NamedLayer>
    	</sld:StyledLayerDescriptor>
    </xsl:template>

</xsl:stylesheet>
