<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="https://standaarden.overheid.nl/lvbb/stop/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="https://standaarden.overheid.nl/stop/imop/geo/ ../Bitbucket/imop_0.98.4-kern/stop/Basisgeometrie.xsd">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="GML.xsl"/>
    
    <!-- verwijder 'xmnl=...' uit om te zetten xml document-->

    <!-- Haalt de gml uit de 0.97 versie van een OP document (Besluit) -->
    <xsl:template match="/Besluit/Metadata/Uitspraak[@eigenschap='imop:heeftDatacollectie']/Object[@type='imop:GeoInformatieobject']" >
        <!-- gml bestand maken-->
        <xsl:call-template name="gmlFile"></xsl:call-template>
        <!-- GIO bestand maken-->
        <xsl:call-template name="GIOFile"></xsl:call-template>
    </xsl:template>
    
    <xsl:template name="gmlFile">
        <xsl:variable name="index" select="fn:format-number(count(ancestor::Object[@type='imop:GeoInformatieobject'])+1,'###000')"/>
        <xsl:variable name="fileName" select="concat(./Eigenschap[@naam='imop:noemer']/Waarde/text(),'_',$index,'.gml')"/>
        <xsl:result-document method="xml" href="{$fileName}" >
            <xsl:element name="geo:FeatureCollectionGeometrie"  inherit-namespaces="yes">
                <xsl:namespace name="geo">http://www.geostandaarden.nl/basisgeometrie/v20190901</xsl:namespace>
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:namespace name="gml">http://www.opengis.net/gml/3.2</xsl:namespace>
                <xsl:attribute name="xsi:schemaLocation">https://standaarden.overheid.nl/stop/imop/geo/ ../Bitbucket/imop_0.98.4-kern/stop/Basisgeometrie.xsd</xsl:attribute>
                <xsl:attribute name="gml:id">main</xsl:attribute>
                <xsl:element name="geo:featureMember">
                    <xsl:element name="geo:Geometrie">
                        <xsl:variable name="geoId" select="./Eigenschap[@naam='imop:inhoud']/Object/@oId"/>
                        <xsl:element name="geo:id">
                            <xsl:value-of select="$geoId"/>
                        </xsl:element>
                        <xsl:element name="geo:geometrie">
                            <xsl:copy-of select="./Eigenschap[@naam='imop:inhoud']/Object/Eigenschap[@naam='imop:geometrie']/Geometrie/child::*" copy-namespaces="no"></xsl:copy-of>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="GIOFile">
        <xsl:variable name="index" select="fn:format-number(count(ancestor::Object[@type='imop:GeoInformatieobject'])+1,'###000')"/>
        <xsl:variable name="fileName" select="concat('GIO','_',$index,'.xml')"/>
        <xsl:variable name="oId" select="./Eigenschap[@naam='imop:inhoud']/Object/@oId"/>
        <xsl:variable name="fileName_gml" select="concat(./Eigenschap[@naam='imop:noemer']/Waarde/text(),'_',$index,'.gml')"/>
        <xsl:result-document method="xml" href="{$fileName}" >
            <xsl:element name="AanleveringGIO" namespace="https://standaarden.overheid.nl/lvbb/stop/" inherit-namespaces="yes">
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:namespace name="gml">http://www.opengis.net/gml/3.2</xsl:namespace>
                <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
                <xsl:attribute name="xsi:schemaLocation">https://standaarden.overheid.nl/stop/imop/geo/ ../Bitbucket/imop_0.98.4-kern/lvbb/LVBB-stop.xsd</xsl:attribute>
                <xsl:attribute name="schemaversion">0.98.3-kern</xsl:attribute>
                <xsl:element name="InformatieObjectVersie">
                    <xsl:element name="ExpressionIdentificatie">
                        <xsl:element name="FRBRWork"><xsl:value-of select="./Eigenschap[@naam='imop:identificatie']/Object[@type='imop:JOINIdentification']/Eigenschap[@naam='imop:FRBRWork']/Object[@type='imop:FRBRWorkIdentification']/Eigenschap[@naam='imop:FRBRthis']/Waarde/text()"/></xsl:element>
                        <xsl:element name="FRBRExpression"><xsl:value-of select="./Eigenschap[@naam='imop:identificatie']/Object[@type='imop:JOINIdentification']/Eigenschap[@naam='imop:FRBRExpression']/Object[@type='imop:FRBRExpressionIdentification']/Eigenschap[@naam='imop:FRBRthis']/Waarde/text()"/></xsl:element>
                        <xsl:element name="soortWork">/join/id/stop/work_007</xsl:element>
                    </xsl:element>
                    <xsl:element name="InformatieObjectMetadata">
                        <xsl:element name="eindverantwoordelijke"><xsl:value-of select="concat('/tooi/id/',fn:lower-case(/Besluit/Metadata/Uitspraak[@eigenschap='imop:typeBevoegdGezag']/Waarde/text()),'/',/Besluit/Metadata/Uitspraak[@eigenschap='imop:bevoegdGezag']/Waarde/text())"/></xsl:element>
                        <xsl:element name="maker"><xsl:value-of select="concat('/tooi/id/',fn:lower-case(/Besluit/Metadata/Uitspraak[@eigenschap='imop:typeBevoegdGezag']/Waarde/text()),'/',/Besluit/Metadata/Uitspraak[@eigenschap='imop:bevoegdGezag']/Waarde/text())"/></xsl:element>
                        <xsl:element name="noemer"><xsl:value-of select="./Eigenschap[@naam='imop:noemer']/Waarde/text()"/></xsl:element>
                        <xsl:element name="officieleTitel"><xsl:value-of select="/Besluit/Metadata/Uitspraak[@eigenschap='imop:citeertitel']/Waarde/text()"/></xsl:element>
                        <xsl:element name="publicatieinstructie">TeConsolideren</xsl:element>
                        <xsl:element name="soortInformatieobject">/join/id/stop/informatieobject/gio_001</xsl:element>
                        <xsl:element name="heeftBestanden">
                            <xsl:element name="heeftBestand">
                                <xsl:element name="Bestand">
                                    <xsl:element name="bestandsnaam"><xsl:value-of select="$fileName_gml"/></xsl:element>
                                    <xsl:element name="hash"></xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="GeoInformatie">
                        <xsl:element name="featureMember">
                            <xsl:element name="Locatie">
                                <xsl:attribute name="gml:id"><xsl:value-of select="fn:replace(./Eigenschap[@naam='imop:noemer']/Waarde/text(),' ','_')"/></xsl:attribute>
                                <xsl:element name="wId"><xsl:value-of select="fn:replace(./Eigenschap[@naam='imop:noemer']/Waarde/text(),' ','_')"/></xsl:element>
                                <xsl:element name="naam"><xsl:value-of select="./Eigenschap[@naam='imop:noemer']/Waarde/text()"/></xsl:element>
                                <xsl:element name="geometrie">
                                    <xsl:attribute name="xlink:href"><xsl:value-of select="concat($fileName_gml,'#',$oId)"/></xsl:attribute>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Achtergrond">
                        <xsl:element name="bronactualiteit"><xsl:value-of select="./Eigenschap[@naam='imop:inhoud']/Object[@oId=$oId]/Eigenschap[@naam='imop:bronactualiteit']/Waarde/text()"/></xsl:element>
                        <xsl:element name="bronbeschrijving"><xsl:value-of select="./Eigenschap[@naam='imop:inhoud']/Object[@oId=$oId]/Eigenschap[@naam='imop:bronbeschrijving']/Waarde/text()"/></xsl:element>
                        <xsl:element name="brontype"><xsl:value-of select="./Eigenschap[@naam='imop:inhoud']/Object[@oId=$oId]/Eigenschap[@naam='imop:brontype']/Waarde/text()"/></xsl:element>
                        <xsl:element name="nauwkeurigheid"><xsl:value-of select="./Eigenschap[@naam='imop:inhoud']/Object[@oId=$oId]/Eigenschap[@naam='imop:nauwkeurigheid']/Waarde/text()"/></xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
            
    </xsl:template>
</xsl:stylesheet>