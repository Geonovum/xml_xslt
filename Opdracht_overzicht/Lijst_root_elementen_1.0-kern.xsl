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
    xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
    xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/"
    xmlns:geo_stop="https://standaarden.overheid.nl/stop/imop/geo/" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:lvbb="http://www.overheid.nl/2017/lvbb" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xsi:schemaLocation="http://www.overheid.nl/imop/def# ../lvbb/LVBB-stop.xsd" 
    xmlns="https://standaarden.overheid.nl/lvbb/stop/">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Pad naar het setje bestanden van de opdracht -->
    <xsl:param name="folder" select="'file:///F:/DSO/Geonovum/GitHub/xml_omgevingsverordening_provincie_utrecht_1.0/opdracht'"/>
    
    <xsl:param name="OP_root" select="'AanleveringBesluit'"/>
    <xsl:param name="GIO_root" select="'AanleveringInformatieObject'"/>
    <xsl:param name="opdracht_root" select="'publicatieOpdracht'"/>
    <xsl:param name="manifest_root" select="'manifest'"></xsl:param>
    <xsl:param name="owBestand_root" select="'owBestand'"></xsl:param>
    
    <xsl:template match="root()" mode="inFile">
        <xsl:for-each select="node() | @*">
            <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                <xsl:value-of select="./local-name()"/>
            </xsl:element>
            <xsl:if test="./local-name() = $OP_root">
                <xsl:element name="UL" namespace="">
                    <xsl:element name="LI" namespace="">Informatie objecten 
                        <xsl:element name="UL" namespace="">
                            <xsl:for-each select="./*[local-name()='BesluitVersie']/*[local-name()='BesluitMetadata']/*[local-name()='informatieobjectRefs']/*[local-name()='informatieobjectRef']">
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
                            <xsl:for-each select="//*[local-name()='IntIoRef']">
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
                            <xsl:for-each select="//*[local-name()='ExtIoRef']">
                                <xsl:element name="LI" namespace="">
                                    <xsl:value-of select="@wId"/> - <xsl:value-of select="@doel"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="./local-name() = $GIO_root">
                <xsl:element name="UL" namespace="">FRBRWork - FRBRExpression - soortWork<xsl:element name="LI" namespace="">
                        <xsl:value-of select="./*[local-name()='InformatieObjectVersie']/*[local-name()='ExpressionIdentificatie']/*[local-name()='FRBRWork']/text()"/> - <xsl:value-of select="./*[local-name()='InformatieObjectVersie']/*[local-name()='ExpressionIdentificatie']/*[local-name()='FRBRExpression']/text()"/> - <xsl:value-of select="./*[local-name()='InformatieObjectVersie']/*[local-name()='ExpressionIdentificatie']/*[local-name()='soortWork']/text()"/>
                    <xsl:element name="UL" namespace="">bestandsnaam - hash<xsl:for-each select="./*[local-name()='InformatieObjectVersie']/*[local-name()='InformatieObjectMetadata']/*[local-name()='heeftBestanden']">
                                <xsl:element name="LI" namespace="">
                                    <xsl:value-of select="./*[local-name()='heeftBestand']/*[local-name()='Bestand']/*[local-name()='bestandsnaam']/text()"/> -<xsl:value-of select="./*[local-name()='heeftBestand']/*[local-name()='Bestand']/*[local-name()='hash']/text()"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    <xsl:element name="UL">geometrie<xsl:for-each select="/*[local-name()='AanleveringGIO']/*[local-name()='InformatieObjectVersie']/*[local-name()='GeoInformatie']/*[local-name()='featureMember']">
                            <xsl:element name="LI" namespace="">
                                <xsl:value-of select="./*[local-name()='Locatie']/*[local-name()='geometrie']/@xlink:href"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="./local-name() = $opdracht_root">
                <xsl:element name="UL" namespace="">
                    <xsl:element name="LI" namespace="">
                        <xsl:value-of select="./*[local-name()='idLevering']/text()"/> - <xsl:value-of select="./*[local-name()='publicatie']/text()"/> - <xsl:value-of select="./*[local-name()='datumBekendmaking']/text()"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="./local-name() = $manifest_root">
                <xsl:for-each select="/*[local-name()='manifest']/*[local-name()='bestand']">
                    <xsl:element name="UL" namespace="">
                        <xsl:element name="LI" namespace="">
                            <xsl:value-of select="./*[local-name()='bestandsnaam']/text()"/> - <xsl:value-of select="./*[local-name()='contentType']/text()"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="./local-name() = $owBestand_root">
                <xsl:element name="UL" namespace="">  
                    <xsl:element name="LI" namespace="">
                        objectType: <xsl:value-of select="/*[local-name()='owBestand']/*[local-name()='standBestand']/*[local-name()='inhoud']/*[local-name()='objectTypen']/*[local-name()='objectType']/text()"/>
                        <xsl:if test="/*[local-name()='owBestand']/*[local-name()='standBestand']/*[local-name()='inhoud']/*[local-name()='objectTypen']/*[local-name()='objectType']/text() = 'Regeltekst'">
                            <xsl:element name="UL" namespace="">
                                <xsl:for-each select="/*[local-name()='owBestand']/*[local-name()='standBestand']/*[local-name()='stand']">
                                    <xsl:if test="./*[local-name()='owObject']/child::element()/local-name()='RegelVoorIedereen'">
                                        <xsl:element name="LI" namespace="">RegelVoorIedereen - <xsl:value-of select="./*[local-name()='owObject']/*[local-name()='RegelVoorIedereen']/@rkow:regeltekstId"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="./ow-dc:owObject/child::element()/local-name()='Regeltekst'">
                                        <xsl:element name="LI" namespace="">Regeltekst - <xsl:value-of select="./*[local-name()='owObject']/*[local-name()='Regeltekst']/*[local-name()='identificatie']/text()"/> - <xsl:value-of select="./*[local-name()='owObject']/*[local-name()='Regeltekst']/@wIdRegeling"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="/*[local-name()='owBestand']/*[local-name()='standBestand']/*[local-name()='inhoud']/*[local-name()='objectTypen']/*[local-name()='objectType']/text() = 'Activiteit'">
                            <xsl:element name="UL" namespace="">
                                <xsl:for-each select="/*[local-name()='owBestand']/*[local-name()='standBestand']/*[local-name()='stand']">
                                    <xsl:element name="LI" namespace="">
                                        <xsl:value-of select="./*[local-name()='owObject']/*[local-name()='Activiteit']/*[local-name()='identificatie']/text()"/> - <xsl:value-of select="./*[local-name()='owObject']/*[local-name()='Activiteit']/@rkow:regeltekstId"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="/*[local-name()='owBestand']/*[local-name()='standBestand']/*[local-name()='inhoud']/*[local-name()='objectTypen']/*[local-name()='objectType']/text() = 'Gebiedsaanwijzing'">
                            <xsl:element name="UL" namespace="">
                                <xsl:for-each select="/*[local-name()='owBestand']/*[local-name()='standBestand']/*[local-name()='stand']">
                                    <xsl:element name="LI" namespace="">
                                        <xsl:value-of select="./*[local-name()='owObject']/*[local-name()='Gebiedsaanwijzing']/*[local-name()='identificatie']/text()"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="/*[local-name()='owBestand']/*[local-name()='standBestand']/*[local-name()='inhoud']/*[local-name()='objectTypen']/*[local-name()='objectType']/text() = 'Gebiedengroep'">
                            <xsl:element name="UL" namespace="">
                                <xsl:for-each select="/*[local-name()='owBestand']/*[local-name()='standBestand']/*[local-name()='stand']">
                                    <xsl:element name="LI" namespace="">
                                        <xsl:value-of select="./*[local-name()='owObject']/*[local-name()='Gebiedengroep']/*[local-name()='identificatie']/text()"/>
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
                <xsl:value-of select="./base-uri()"/>/
                <xsl:value-of select="./*[local-name()='vastgesteldeVersie']/*[local-name()='GeoInformatieObjectVersie']/*[local-name()='locaties']/*[local-name()='Locatie']/*[local-name()='geometrie']/*[local-name()='Geometrie']/*[local-name()='id']/text()"/>
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