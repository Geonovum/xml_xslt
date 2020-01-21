<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    >
    
    <xsl:output encoding="UTF-8"/>
    
    <xsl:variable name="baseGUID" select="'73b15775-5471-447e-9723-5e7b377'"/>
    
    <xsl:template match="/">
        <xsl:variable name="GML">
            <geo:FeatureCollectionGeometrie xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gml="http://www.opengis.net/gml/3.2"
                xsi:schemaLocation="https://standaarden.overheid.nl/stop/imop/geo/ https://raw.githubusercontent.com/Geonovum/xml_ow_xsd_0.98.2-kern/master/xsd/basisgeometrie/v20190901/geometrie.xsd"
                gml:id="main">
                <xsl:for-each select="/geo:FeatureCollectionGeometrie/geo:featureMember">
                    <xsl:element name="geo:featureMember">
                        <xsl:element name="geo:Geometrie">
                            <xsl:variable name="guid" select="concat($baseGUID, format-number(position(),'0000'))"/>
                            <xsl:element name="geo:id"><xsl:value-of select="$guid"/></xsl:element>
                            <xsl:element name="geo:geometrie">
                                <xsl:element name="gml:MultiSurface">
                                    <xsl:attribute name="srsName" select="*//gml:MultiSurface/@srsName"></xsl:attribute>
                                    <xsl:variable name="idGuid" select="concat('id-',$guid,'-0')"/>
                                    <xsl:attribute name="gml:id"><xsl:value-of select="$idGuid"/></xsl:attribute>
                                    <xsl:for-each select="*//gml:surfaceMember">
                                        <xsl:element name="gml:surfaceMember">
                                            <xsl:element name="gml:Polygon">
                                                <xsl:attribute name="gml:id"><xsl:value-of select="concat($idGuid,'-',position()-1)"/></xsl:attribute>
                                                <xsl:copy-of select="*//gml:exterior"></xsl:copy-of>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </geo:FeatureCollectionGeometrie>
        </xsl:variable>
        <xsl:result-document href="GML.gml">
            <xsl:copy-of select="$GML"/>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>