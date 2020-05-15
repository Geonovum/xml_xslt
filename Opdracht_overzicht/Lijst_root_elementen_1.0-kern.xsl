<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" xmlns:imop="https://standaarden.overheid.nl/lvbb/stop/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ogr="http://ogr.maptools.org/" xmlns:saxon="http://saxon.sf.net/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" xmlns:g="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" xmlns:ga-ref="http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901" xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901" xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901" xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709" xmlns:rkow="http://www.geostandaarden.nl/imow/owobject/v20190709" xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901" xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190901" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/" xmlns:geo_stop="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.overheid.nl/imop/def# ../lvbb/LVBB-stop.xsd" xmlns="https://standaarden.overheid.nl/lvbb/stop/">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <!-- Pad naar het setje bestanden van de opdracht -->
    <xsl:param name="folder" select="'file:///F:/DSO/Geonovum/GitHub/xml_omgevingsverordening_provincie_utrecht_1.0/opdracht'"/>
    <xsl:param name="OP_root" select="'AanleveringBesluit'"/>
    <xsl:param name="GIO_root" select="'AanleveringInformatieObject'"/>
    <xsl:param name="opdracht_root" select="'publicatieOpdracht'"/>
    <xsl:param name="manifest_root" select="'manifest'"/>
    <xsl:param name="GML_root" select="'GeoInformatieObjectVaststelling'"/>
    <xsl:param name="manifest-ow_root" select="'Modules'"/>
    <xsl:param name="owBestand_root" select="'owBestand'"/>
    <xsl:param name="objecttype_Regeltekst" select="'Regeltekst'"/>
    <xsl:param name="regeltekst_regelvooriedereen" select="'RegelVoorIedereen'"/>
    
    <xsl:template match=".[local-name() = $OP_root]">
        <xsl:element name="UL" namespace="">
            <xsl:element name="LI" namespace="">Informatie objecten <xsl:element name="UL" namespace="">
                    <xsl:for-each select="./*[local-name() = 'BesluitVersie']/*[local-name() = 'BesluitMetadata']/*[local-name() = 'informatieobjectRefs']/*[local-name() = 'informatieobjectRef']">
                        <xsl:element name="LI" namespace="">
                            <xsl:value-of select="text()"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        <xsl:element name="UL" namespace="">
            <xsl:element name="LI" namespace="">IntIoRef <xsl:element name="UL" namespace="">
                    <xsl:for-each select="//*[local-name() = 'IntIoRef']">
                        <xsl:element name="LI" namespace="">
                            <xsl:value-of select="@ref"/> - <xsl:value-of select="text()"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        <xsl:element name="UL" namespace="">
            <xsl:element name="LI" namespace="">ExtIoRef <xsl:element name="UL" namespace="">
                    <xsl:for-each select="//*[local-name() = 'ExtIoRef']">
                        <xsl:element name="LI" namespace="">
                            <xsl:value-of select="@wId"/> - <xsl:value-of select="@ref"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match=".[local-name() = $manifest-ow_root]">
        <xsl:element name="UL" namespace="">domein: <xsl:element name="LI" namespace="">
                <xsl:value-of select="/root()/element()/*[local-name() = 'domein']/text()"/>
            </xsl:element>
            <xsl:element name="UL">RegelingVersie <xsl:element name="LI">
                    <xsl:value-of select=".//*[local-name() = 'FRBRwork']"/> - <xsl:value-of select=".//*[local-name() = 'FRBRExpression']"/>
                </xsl:element>
            </xsl:element>
            <xsl:for-each select=".//*[local-name() = 'Bestand']">
                <xsl:element name="UL">
                    <xsl:element name="LI">
                        <xsl:value-of select="./*[local-name() = 'naam']/text()"/>
                        <xsl:for-each select="./*[local-name() = 'objecttype']">
                            <xsl:element name="UL">
                                <xsl:element name="LI">
                                    <xsl:value-of select="./text()"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                        <xsl:element name="LU"> </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match=".[local-name() = $GIO_root]">
        <xsl:element name="UL" namespace="">FRBRWork - FRBRExpression - soortWork<xsl:element name="LI" namespace="">
                <xsl:value-of select="./*[local-name() = 'InformatieObjectVersie']/*[local-name() = 'ExpressionIdentificatie']/*[local-name() = 'FRBRWork']/text()" /> - <xsl:value-of select="./*[local-name() = 'InformatieObjectVersie']/*[local-name() = 'ExpressionIdentificatie']/*[local-name() = 'FRBRExpression']/text()" /> - <xsl:value-of select="./*[local-name() = 'InformatieObjectVersie']/*[local-name() = 'ExpressionIdentificatie']/*[local-name() = 'soortWork']/text()"/>
                <xsl:variable name="gml_bestandsnaam" select="./*[local-name() = 'InformatieObjectVersie']/*[local-name() = 'InformatieObjectMetadata']/*[local-name() = 'heeftBestanden']/*[local-name() = 'heeftBestand']/*[local-name() = 'Bestand']/*[local-name() = 'bestandsnaam']/text()"/>
                <xsl:element name="UL" namespace="">bestandsnaam - hash<xsl:for-each select="./*[local-name() = 'InformatieObjectVersie']/*[local-name() = 'InformatieObjectMetadata']/*[local-name() = 'heeftBestanden']">
                        <xsl:element name="LI" namespace="">
                            <xsl:value-of select="$gml_bestandsnaam"/> - <xsl:value-of select="./*[local-name() = 'heeftBestand']/*[local-name() = 'Bestand']/*[local-name() = 'hash']/text()" />
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
                <xsl:element name="UL">>> GML: FRBRWork - FRBRExpression<xsl:element name="LI" namespace="">
                        <xsl:value-of select="collection(concat($folder, '?select=', $gml_bestandsnaam, ';recurse=yes'))/root()/element()//*[local-name() = 'FRBRWork']/text()" /> - <xsl:value-of select="collection(concat($folder, '?select=', $gml_bestandsnaam, ';recurse=yes'))/root()/element()//*[local-name() = 'FRBRExpression']/text()"/>
                        <xsl:for-each select="collection(concat($folder, '?select=', $gml_bestandsnaam, ';recurse=yes'))/root()/element()//*[local-name() = 'Geometrie']">
                            <xsl:element name="LI" namespace="">
                                <xsl:value-of select="./@gml:id"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match=".[local-name() = $opdracht_root]">
        <xsl:element name="UL" namespace="">
            <xsl:element name="LI" namespace="">
                <xsl:value-of select="./*[local-name() = 'idLevering']/text()"/> - <xsl:value-of select="./*[local-name() = 'publicatie']/text()"/> - <xsl:value-of select="./*[local-name() = 'datumBekendmaking']/text()"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match=".[local-name() = $manifest_root]">
        <xsl:for-each select="/*[local-name() = 'manifest']/*[local-name() = 'bestand']">
            <xsl:element name="UL" namespace="">
                <xsl:element name="LI" namespace="">
                    <xsl:value-of select="./*[local-name() = 'bestandsnaam']/text()"/> -<xsl:value-of select="./*[local-name() = 'contentType']/text()"/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match=".[local-name() = $owBestand_root]">
        <xsl:element name="UL" namespace="">
            <xsl:element name="LI" namespace=""> objectType: <xsl:value-of select="/*[local-name() = 'owBestand']/*[local-name() = 'standBestand']/*[local-name() = 'inhoud']/*[local-name() = 'objectTypen']/*[local-name() = 'objectType']/text()"/>
                <xsl:if test="/*[local-name() = 'owBestand']/*[local-name() = 'standBestand']/*[local-name() = 'inhoud']/*[local-name() = 'objectTypen']/*[local-name() = 'objectType']/text() = 'Regeltekst'">
                    <xsl:element name="UL" namespace="">
                        <xsl:for-each select="/*[local-name() = 'owBestand']/*[local-name() = 'standBestand']/*[local-name() = 'stand']">
                            <xsl:if test="./*[local-name() = 'owObject']/child::element()/local-name() = 'RegelVoorIedereen'">
                                <xsl:element name="LI" namespace="">RegelVoorIedereen -<xsl:value-of select="./*[local-name() = 'owObject']/*[local-name() = 'RegelVoorIedereen']/@rkow:regeltekstId" />
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="./ow-dc:owObject/child::element()/local-name() = 'Regeltekst'">
                                <xsl:element name="LI" namespace="">Regeltekst - <xsl:value-of select="./*[local-name() = 'owObject']/*[local-name() = 'Regeltekst']/*[local-name() = 'identificatie']/text()" /> - <xsl:value-of select="./*[local-name() = 'owObject']/*[local-name() = 'Regeltekst']/@wIdRegeling" />
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="/*[local-name() = 'owBestand']/*[local-name() = 'standBestand']/*[local-name() = 'inhoud']/*[local-name() = 'objectTypen']/*[local-name() = 'objectType']/text() = 'Activiteit'">
                    <xsl:element name="UL" namespace="">
                        <xsl:for-each select="/*[local-name() = 'owBestand']/*[local-name() = 'standBestand']/*[local-name() = 'stand']">
                            <xsl:element name="LI" namespace="">
                                <xsl:value-of select="./*[local-name() = 'owObject']/*[local-name() = 'Activiteit']/*[local-name() = 'identificatie']/text()" /> - <xsl:value-of select="./*[local-name() = 'owObject']/*[local-name() = 'Activiteit']/*[local-name() = 'naam']/text()" />
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="/*[local-name() = 'owBestand']/*[local-name() = 'standBestand']/*[local-name() = 'inhoud']/*[local-name() = 'objectTypen']/*[local-name() = 'objectType']/text() = 'Gebiedsaanwijzing'">
                    <xsl:element name="UL" namespace="">
                        <xsl:for-each select="/*[local-name() = 'owBestand']/*[local-name() = 'standBestand']/*[local-name() = 'stand']">
                            <xsl:element name="LI" namespace="">
                                <xsl:value-of select="./*[local-name() = 'owObject']/*[local-name() = 'Gebiedsaanwijzing']/*[local-name() = 'identificatie']/text()" />
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="/*[local-name() = 'owBestand']/*[local-name() = 'standBestand']/*[local-name() = 'inhoud']/*[local-name() = 'objectTypen']/*[local-name() = 'objectType']/text() = 'Gebiedengroep'">
                    <xsl:element name="UL" namespace="">
                        <xsl:for-each select="/*[local-name() = 'owBestand']/*[local-name() = 'standBestand']/*[local-name() = 'stand']">
                            <xsl:element name="LI" namespace="">
                                <xsl:value-of select="./*[local-name() = 'owObject']/*[local-name() = 'Gebiedengroep']/*[local-name() = 'identificatie']/text()"/>
                                <xsl:element name="UL" namespace=""> </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="/" mode="locatie">
        <xsl:param name="loc_ref"/>
        <xsl:variable name="ow_locatie" select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name() = 'identificatie'][text() = $loc_ref]"/>
        <xsl:element name="LI">
            <xsl:value-of select="$loc_ref"/>
        </xsl:element>
        <xsl:element name="LI">
            <xsl:value-of select="$ow_locatie/../*[local-name() = 'noemer']" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="root()" mode="inFile">
        <xsl:for-each select="node() | @*">
            <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                <xsl:attribute name="style" select="'background-color:black;color:white'"/>
                <xsl:value-of select="./local-name()"/>
            </xsl:element>
            <xsl:element name="UL">
                <xsl:attribute name="style" select="'background-color:#eeeeee'"/>
                <xsl:element name="LI">Regeling: <xsl:element name="UL">
                    <xsl:variable name="opschrift" select="./*[local-name() = 'BesluitVersie']/*[local-name() = 'BesluitCompact']/*[local-name() = 'WijzigBijlage']/*[local-name() = 'RegelingCompact']/*[local-name() = 'RegelingOpschrift']/*[local-name() = 'Al']/text()"/>
                    <xsl:element name="LI">
                        <xsl:value-of select="concat('Opschrift: ',$opschrift)" />
                    </xsl:element>
                    </xsl:element>
                    <xsl:element name="UL">
                        <xsl:element name="LI">wordt: <xsl:value-of select="./*[local-name() = 'BesluitVersie']/*[local-name() = 'BesluitCompact']/*[local-name() = 'WijzigBijlage']/*[local-name() = 'RegelingCompact']/@wordt" />
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="UL">
                        <xsl:element name="LI">Doelen: <xsl:for-each select="./*[local-name() = 'BesluitVersie']/*[local-name() = 'ConsolidatieInformatie']/*[local-name() = 'Tijdstempels']">
                                <xsl:element name="UL">
                                    <xsl:element name="LI"> Doel: <xsl:value-of select="./*[local-name() = 'Tijdstempel']/*[local-name() = 'doel']//text()" />
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="UL">
                                    <xsl:element name="LI"> soort: <xsl:value-of select="./*[local-name() = 'Tijdstempel']/*[local-name() = 'soortTijdstempel']//text()" />
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="UL">
                                    <xsl:element name="LI"> datum: <xsl:value-of select="./*[local-name() = 'Tijdstempel']/*[local-name() = 'datum']//text()" />
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="UL">
                        <xsl:element name="LI">Artikelen <xsl:for-each select="./*[local-name() = 'BesluitVersie']/*[local-name() = 'BesluitCompact']/*[local-name() = 'WijzigBijlage']/*[local-name() = 'RegelingCompact']/*[local-name() = 'Lichaam']//*[local-name() = 'Artikel']">
                                <xsl:element name="UL">
                                    <xsl:variable name="zoek_wId" select="./@wId"/>
                                    <xsl:element name="LI">wId: <xsl:value-of select="$zoek_wId"/>
                                    </xsl:element>
                                    <xsl:element name="LI">Artikel: <xsl:value-of select="./*[local-name() = 'Kop']/*[local-name() = 'Nummer']/text()" />
                                    </xsl:element>
                                    <xsl:element name="LI">Opschrift: <xsl:value-of select="./*[local-name() = 'Kop']/*[local-name() = 'Opschrift']/text()" />
                                    </xsl:element>
                                    <xsl:element name="LI">Inhoud: <xsl:value-of select="./*[local-name() = 'Inhoud']"/>
                                    </xsl:element>
                                    <xsl:element name="UL">
                                        <xsl:element name="LI">Regeltekst <xsl:variable name="ow_regeltekst" select="collection(concat($folder, '?select=*.xml;recurse=yes'))[root()/element()//*[local-name() = 'objectType'] = 'Regeltekst']"/>
                                            <xsl:for-each select="$ow_regeltekst/root()/element()//*[@wId = $zoek_wId]/*[local-name() = 'identificatie']">
                                                <xsl:variable name="regel_id" select="./text()"/>
                                                <xsl:element name="UL">
                                                    <xsl:element name="LI">
                                                        <xsl:for-each select="$ow_regeltekst/root()/element()//*[@xlink:href = $regel_id]">
                                                            <xsl:value-of select="./../../local-name()"/>
                                                            <xsl:element name="UL">
                                                                <xsl:element name="LI">
                                                                    <xsl:value-of select="$regel_id"/>
                                                                </xsl:element>
                                                                <xsl:for-each select="./../../*[local-name() = 'locatieaanduiding']">
                                                                    <xsl:element name="LI">Locatieaanduiding:<xsl:element name="UL">
                                                                            <xsl:apply-templates mode="locatie" select="/">
                                                                                <xsl:with-param name="loc_ref" select="./*[local-name() = 'LocatieRef']/@xlink:href"/>
                                                                            </xsl:apply-templates>
                                                                        </xsl:element>
                                                                    </xsl:element>
                                                                </xsl:for-each>
                                                                <xsl:for-each select="./../../*[local-name() = 'gebiedsaanwijzing']">
                                                                    <xsl:element name="LI">Gebiedsaanwijzing:<xsl:element name="UL">
                                                                            <xsl:variable name="gebiedsaanwijzing_ref" select="./*[local-name() = 'GebiedsaanwijzingRef']/@xlink:href"/>
                                                                            <xsl:variable name="ow_gebiedsaanwijzing" select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name() = 'identificatie'][text() = $gebiedsaanwijzing_ref]"/>
                                                                            <xsl:element name="LI">
                                                                                <xsl:value-of select="$gebiedsaanwijzing_ref"/>
                                                                            </xsl:element>
                                                                            <xsl:element name="LI">
                                                                                <xsl:value-of select="$ow_gebiedsaanwijzing/../*[local-name() = 'type']" />
                                                                            </xsl:element>
                                                                            <xsl:element name="LI">
                                                                                <xsl:value-of select="$ow_gebiedsaanwijzing/../*[local-name() = 'naam']" />
                                                                            </xsl:element>
                                                                            <xsl:element name="LI">Locatieaanduiding: <xsl:element name="UL">
                                                                                    <xsl:apply-templates mode="locatie" select="/">
                                                                                        <xsl:with-param name="loc_ref" select="$ow_gebiedsaanwijzing/../*[local-name()='locatieaanduiding']/*[local-name()='LocatieRef']/@xlink:href"/>
                                                                                    </xsl:apply-templates>
                                                                                </xsl:element>
                                                                            </xsl:element>
                                                                        </xsl:element>
                                                                    </xsl:element>
                                                                </xsl:for-each>
                                                                <xsl:for-each select="./../../*[local-name() = 'activiteitaanduiding']">
                                                                    <xsl:element name="LI">Activiteitaanduiding: 
                                                                        <xsl:element name="UL">
                                                                            <xsl:variable name="activiteit_ref" select="./*[local-name() = 'ActiviteitRef']/@xlink:href"/>
                                                                            <xsl:variable name="ow_activiteit" select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name() = 'identificatie'][text() = $activiteit_ref]"/>
                                                                            <xsl:element name="LI">
                                                                                <xsl:value-of select="$activiteit_ref"/>
                                                                            </xsl:element>
                                                                            <xsl:element name="LI">
                                                                                <xsl:value-of select="$ow_activiteit/../*[local-name() = 'naam']" />
                                                                            </xsl:element>
                                                                            <xsl:element name="LI">
                                                                                <xsl:value-of select="$ow_activiteit/../*[local-name() = 'groep']" />
                                                                            </xsl:element>
                                                                        </xsl:element>
                                                                    </xsl:element>
                                                                </xsl:for-each>
                                                            </xsl:element>
                                                        </xsl:for-each>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:for-each>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="UL">
                        <xsl:element name="LI"> </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="root()" mode="GMLFiles">
        <xsl:for-each select="node() | @*">
            <xsl:element name="LI" namespace="">
                <xsl:value-of select="./base-uri()"/>/ <xsl:value-of select="./*[local-name() = 'vastgesteldeVersie']/*[local-name() = 'GeoInformatieObjectVersie']/*[local-name() = 'locaties']/*[local-name() = 'Locatie']/*[local-name() = 'geometrie']/*[local-name() = 'Geometrie']/*[local-name() = 'id']/text()" />
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