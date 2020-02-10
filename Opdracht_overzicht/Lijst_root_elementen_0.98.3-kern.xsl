<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" 
    xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" 
    xmlns:imop="https://standaarden.overheid.nl/lvbb/stop/" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:ogr="http://ogr.maptools.org/" 
    xmlns:saxon="http://saxon.sf.net/" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901" 
    xmlns:gml="http://www.opengis.net/gml/3.2" 
    xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901" 
    xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" 
    xmlns:g="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" 
    xmlns:ga-ref="http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709" 
    xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709" 
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301" 
    xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901" 
    xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901" 
    xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901" 
    xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709" 
    xmlns:rkow="http://www.geostandaarden.nl/imow/owobject/v20190709" 
    xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901" 
    xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190901" 
    xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901" 
    xmlns:geo_stop="https://standaarden.overheid.nl/stop/imop/geo/" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:lvbb="http://www.overheid.nl/2017/lvbb" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xsi:schemaLocation="http://www.overheid.nl/imop/def# ../lvbb/LVBB-stop.xsd" 
    xmlns="https://standaarden.overheid.nl/lvbb/stop/">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Pad naar het setje bestanden van de opdracht -->
    <xsl:param name="folder" select="'file:///E:/DSO/Geonovum/GitHub/xml_omgevingsplan_hillegom_0.98.3-kern/opdracht'"/>

    <xsl:template match="root()" mode="inFile">
        <xsl:for-each select="node() | @*">
            <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                <xsl:value-of select="root()/element()/name()"/>
            </xsl:element>
            <xsl:if test="root()/element()/name() = 'AanleveringBesluit' or fn:substring-after(root()/element()/name(), ':') = 'AanleveringBesluit'">
                <xsl:element name="UL" namespace="">
                    <xsl:element name="LI" namespace="">Informatie objecten 
                        <xsl:element name="UL" namespace="">
                            <xsl:for-each select="/imop:AanleveringBesluit/imop:BesluitVersie/data:BesluitMetadata/data:informatieobjectRefs/data:informatieobjectRef">
                                <xsl:element name="LI" namespace="">
                                    <xsl:value-of select="text()"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="UL" namespace="">
                    <xsl:element name="LI" namespace="">IntIoRef
                        <xsl:element name="UL" namespace="">
                            <xsl:for-each select="//tekst:IntIoRef">
                                <xsl:element name="LI" namespace="">
                                    <xsl:value-of select="@doel"/> - <xsl:value-of select="text()"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="UL" namespace="">
                    <xsl:element name="LI" namespace="">ExtIoRef
                        <xsl:element name="UL" namespace="">
                            <xsl:for-each select="//tekst:ExtIoRef">
                                <xsl:element name="LI" namespace="">
                                    <xsl:value-of select="@wId"/> - <xsl:value-of select="@doel"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="root()/element()/name() = 'AanleveringGIO' or fn:substring-after(root()/element()/name(), ':') = 'AanleveringGIO'">
                <xsl:element name="UL" namespace="">FRBRWork - FRBRExpression - soortWork<xsl:element name="LI" namespace="">
                        <xsl:value-of select="/imop:AanleveringGIO/imop:InformatieObjectVersie/data:ExpressionIdentificatie/data:FRBRWork/text()"/> - <xsl:value-of select="/imop:AanleveringGIO/imop:InformatieObjectVersie/data:ExpressionIdentificatie/data:FRBRExpression/text()"/> - <xsl:value-of select="/imop:AanleveringGIO/imop:InformatieObjectVersie/data:ExpressionIdentificatie/data:soortWork/text()"/>
                        <xsl:element name="UL" namespace="">bestandsnaam - hash<xsl:for-each select="/imop:AanleveringGIO/imop:InformatieObjectVersie[1]/data:InformatieObjectMetadata/data:heeftBestanden">
                                <xsl:element name="LI" namespace="">
                                    <xsl:value-of select="./data:heeftBestand/data:Bestand/data:bestandsnaam/text()"/> -<xsl:value-of select="./data:heeftBestand/data:Bestand/data:hash/text()"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:element name="UL">geometrie<xsl:for-each select="/imop:AanleveringGIO/imop:InformatieObjectVersie[1]/geo_stop:GeoInformatie[1]/geo_stop:featureMember">
                            <xsl:element name="LI" namespace="">
                                    <xsl:value-of select="./geo_stop:Locatie/geo_stop:geometrie/@xlink:href"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="root()/element()/name() = 'publicatieOpdracht' or fn:substring-after(root()/element()/name(), ':') = 'publicatieOpdracht'">
                <xsl:element name="UL" namespace="">
                    <xsl:element name="LI" namespace="">
                        <xsl:value-of select="/lvbb:publicatieOpdracht/lvbb:idLevering[1]/text()"/> - <xsl:value-of select="/lvbb:publicatieOpdracht/lvbb:publicatie/text()"/> - <xsl:value-of select="/lvbb:publicatieOpdracht/lvbb:datumBekendmaking/text()"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="root()/element()/name() = 'manifest' or fn:substring-after(root()/element()/name(), ':') = 'manifest'">
                <xsl:for-each select="/lvbb:manifest/lvbb:bestand">
                    <xsl:element name="UL" namespace="">
                        <xsl:element name="LI" namespace="">
                            <xsl:value-of select="./lvbb:bestandsnaam/text()"/> - <xsl:value-of select="./lvbb:contentType/text()"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="root()/element()/name() = 'owBestand' or fn:substring-after(root()/element()/name(), ':') = 'owBestand'">
                <xsl:element name="UL" namespace="">  
                    <xsl:element name="LI" namespace="">
                        objectType: <xsl:value-of select="/ow-dc:owBestand/sl:standBestand[1]/sl:inhoud[1]/sl:objectTypen[1]/sl:objectType[1]/text()"/>
                        <xsl:if test="/ow-dc:owBestand/sl:standBestand[1]/sl:inhoud[1]/sl:objectTypen[1]/sl:objectType[1]/text() = 'Regeltekst'">
                            <xsl:element name="UL" namespace="">
                                <xsl:for-each select="/ow-dc:owBestand/sl:standBestand[1]/sl:stand">
                                    <xsl:if test="./ow-dc:owObject/child::element()/name()='r:RegelVoorIedereen'">
                                        <xsl:element name="LI" namespace="">RegelVoorIedereen - <xsl:value-of select="./ow-dc:owObject[1]/r:RegelVoorIedereen[1]/@rkow:regeltekstId"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="./ow-dc:owObject/child::element()/name()='r:Regeltekst'">
                                        <xsl:element name="LI" namespace="">Regeltekst - <xsl:value-of select="./ow-dc:owObject[1]/r:Regeltekst[1]/r:identificatie[1]/text()"/> - <xsl:value-of select="./ow-dc:owObject[1]/r:Regeltekst[1]/@wIdRegeling"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="/ow-dc:owBestand/sl:standBestand[1]/sl:inhoud[1]/sl:objectTypen[1]/sl:objectType[1]/text() = 'Activiteit'">
                            <xsl:element name="UL" namespace="">
                                <xsl:for-each select="/ow-dc:owBestand/sl:standBestand[1]/sl:stand">
                                    <xsl:element name="LI" namespace="">
                                        <xsl:value-of select="./ow-dc:owObject[1]/rol:Activiteit[1]/rol:identificatie[1]/text()"/> - <xsl:value-of select="./ow-dc:owObject[1]/rol:Activiteit[1]/@rkow:regeltekstId"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="/ow-dc:owBestand/sl:standBestand[1]/sl:inhoud[1]/sl:objectTypen[1]/sl:objectType[1]/text() = 'Gebiedsaanwijzing'">
                            <xsl:element name="UL" namespace="">
                                <xsl:for-each select="/ow-dc:owBestand/sl:standBestand[1]/sl:stand">
                                    <xsl:element name="LI" namespace="">
                                        <xsl:value-of select="./ow-dc:owObject[1]/g:Gebiedsaanwijzing[1]/g:identificatie[1]/text()"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="/ow-dc:owBestand/sl:standBestand[1]/sl:inhoud[1]/sl:objectTypen[1]/sl:objectType[1]/text() = 'Gebiedengroep'">
                            <xsl:element name="UL" namespace="">
                                <xsl:for-each select="/ow-dc:owBestand/sl:standBestand[1]/sl:stand">
                                    <xsl:element name="LI" namespace="">
                                        <xsl:value-of select="./ow-dc:owObject[1]/l:Gebiedengroep[1]/l:identificatie[1]/text()"/>
                                        <xsl:element name="UL" namespace=""> </xsl:element>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="root()" mode="GMLFiles">
        <xsl:for-each select="node() | @*">
            <xsl:element name="LI" namespace="">
                <xsl:value-of select="/geo:FeatureCollectionGeometrie/geo:featureMember[1]/geo:Geometrie[1]/geo:id[1]/text()"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="/">
        <xsl:element name="html" namespace="">
            <xsl:element name="body" namespace="">
                <xsl:element name="UL" namespace="">
                    <xsl:apply-templates mode="inFile" select="collection(concat($folder, '?select=*.xml;recurse=yes'))"/>
                </xsl:element>
                <xsl:element name="UL" namespace=""> GML <xsl:apply-templates mode="GMLFiles" select="collection(concat($folder, '?select=*.gml;recurse=yes'))"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>