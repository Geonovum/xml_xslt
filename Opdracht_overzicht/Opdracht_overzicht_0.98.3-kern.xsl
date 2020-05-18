<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" xmlns:imop="https://standaarden.overheid.nl/lvbb/stop/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ogr="http://ogr.maptools.org/" xmlns:saxon="http://saxon.sf.net/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" xmlns:g="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" xmlns:ga-ref="http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901" xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901" xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901" xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709" xmlns:rkow="http://www.geostandaarden.nl/imow/owobject/v20190709" xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901" xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190901" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/" xmlns:geo_stop="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.overheid.nl/imop/def# ../lvbb/LVBB-stop.xsd" xmlns="https://standaarden.overheid.nl/lvbb/stop/">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <!-- Pad naar het setje bestanden van de opdracht -->
    <xsl:param name="folder" select="'file:///F:/DSO/Geonovum/GitHub/xml_omgevingsplan_gemeentestad_0.98.3-kern/Opdracht'"/>
    <!-- de naam van het root element van het OP bestand -->
    <xsl:param name="OP_root" select="'AanleveringBesluit'"/>
    <!-- template voor op bestand -->
    <xsl:template match="." mode="list">
        <xsl:element name="LI" inherit-namespaces="yes" namespace="">
            <xsl:attribute name="style" select="'background-color:black;color:white'"/>
            <xsl:value-of select="./local-name()"/>
        </xsl:element>
        <xsl:element name="UL">
            <xsl:attribute name="style" select="'background-color:#eeeeee'"/>
            <xsl:variable name="besluitversie" select="./*[local-name()='BesluitVersie']"/>
            <xsl:variable name="regeling" select="./*[local-name()='BesluitVersie']/*[local-name()='Besluit']/*[local-name()='Regeling']/*[local-name()='WijzigBijlage']/*[local-name()='MaakInitieleRegeling']"/>
            <xsl:element name="LI">Regeling: 
                <xsl:element name="UL">
                    <xsl:variable name="opschrift" select="$regeling/*[local-name()='RegelingOpschrift']/*[local-name()='Al']/text()"/>
                    <xsl:element name="LI">Opschrift: <xsl:element name="FONT"><xsl:attribute name="style" select="'font-weight:bold'"/><xsl:value-of select="$opschrift" /></xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="UL">
                    <xsl:element name="LI">Wordt: <xsl:element name="FONT"><xsl:attribute name="style" select="'font-weight:bold'"/><xsl:value-of select="$regeling/@wordt" /></xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="UL">
                    <xsl:element name="LI">Doelen: <xsl:for-each select="./*[local-name()='BesluitVersie']/*[local-name()='ConsolidatieInformatie']/*[local-name()='Tijdstempels']">
                            <xsl:element name="UL">
                                <xsl:element name="LI">Doel: <xsl:value-of select="./*[local-name()='Tijdstempel']/*[local-name()='doel']//text()" />
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="UL">
                                <xsl:element name="LI">Soort: <xsl:value-of select="./*[local-name()='Tijdstempel']/*[local-name()='soortTijdstempel']//text()" />
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="UL">
                                <xsl:element name="LI">Datum: <xsl:value-of select="./*[local-name()='Tijdstempel']/*[local-name()='datum']//text()" />
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="UL">
                    <xsl:element name="LI">Artikelen: <xsl:for-each select="$regeling/*[local-name()='Lichaam']//*[local-name()='Artikel']">
                            <xsl:element name="UL">
                                <xsl:variable name="zoek_wId" select="./@wId"/>
                                <xsl:element name="LI">wId: <xsl:value-of select="$zoek_wId"/>
                                </xsl:element>
                                <xsl:element name="LI">Artikel: <xsl:value-of select="./*[local-name()='Kop']/*[local-name()='Nummer']/text()" />
                                </xsl:element>
                                <xsl:element name="LI">Opschrift: <xsl:value-of select="./*[local-name()='Kop']/*[local-name()='Opschrift']/text()" />
                                </xsl:element>
                                <xsl:element name="LI">Inhoud: <xsl:value-of select="./*[local-name()='Inhoud']"/>
                                </xsl:element>
<!--                                <xsl:element name="LI">
                                    <xsl:variable name="inhoud" select="./*[local-name()='Inhoud']/*"/>
                                    <xsl:copy>
                                        <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                                        <xsl:copy-of select="$inhoud"/>
                                        <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
                                    </xsl:copy>
                                </xsl:element>
-->                                    <xsl:element name="LI"><xsl:attribute name="style" select="'background-color:#cccccc'"/>Regeltekst(en): <xsl:variable name="ow_regeltekst" select="collection(concat($folder, '?select=*.xml;recurse=yes'))[root()/element()//*[local-name()='objectType']='Regeltekst']"/>
                                        <xsl:for-each select="$ow_regeltekst/root()/element()//*[@wId=$zoek_wId]/*[local-name()='identificatie']">
                                            <xsl:variable name="regel_id" select="./text()"/>
                                            <xsl:element name="UL">
                                                
                                                <xsl:element name="LI">
                                                    <xsl:for-each select="$ow_regeltekst/root()/element()//*[@xlink:href=$regel_id]">
                                                        Juridische regel: <xsl:value-of select="./../../local-name()"/>
                                                        <xsl:element name="UL">
                                                            <xsl:element name="LI">Identificatie: 
                                                                <xsl:value-of select="$regel_id"/>
                                                            </xsl:element>
                                                            <xsl:for-each select="./../../*[local-name()='locatieaanduiding']">
                                                                <xsl:element name="LI">Locatieaanduiding:<xsl:element name="UL">
                                                                        <xsl:attribute name="style" select="'background-color:#707070'"/>
                                                                        <xsl:apply-templates mode="locatie" select="./*[local-name()='LocatieRef']"/>
                                                                    </xsl:element>
                                                                </xsl:element>
                                                            </xsl:for-each>
                                                            <xsl:for-each select="./../../*[local-name()='gebiedsaanwijzing']">
                                                                <xsl:element name="LI">Gebiedsaanwijzing:<xsl:element name="UL">
                                                                        <xsl:attribute name="style" select="'background-color:#909090'"/>
                                                                        <xsl:variable name="gebiedsaanwijzing_ref" select="./*[local-name()='GebiedsaanwijzingRef']/@xlink:href"/>
                                                                        <xsl:variable name="ow_gebiedsaanwijzing" select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name()='identificatie'][text()=$gebiedsaanwijzing_ref]"/>
                                                                        <xsl:element name="LI">Identificatie
                                                                            <xsl:value-of select="$gebiedsaanwijzing_ref"/>
                                                                        </xsl:element>
                                                                        <xsl:element name="LI">Type: 
                                                                            <xsl:value-of select="$ow_gebiedsaanwijzing/../*[local-name()='type']" />
                                                                        </xsl:element>
                                                                        <xsl:element name="LI">Naam: 
                                                                            <xsl:value-of select="$ow_gebiedsaanwijzing/../*[local-name()='naam']" />
                                                                        </xsl:element>
                                                                        <xsl:element name="LI">Locatieaanduiding: <xsl:element name="UL">
                                                                                <xsl:attribute name="style" select="'background-color:#707070'"/>
                                                                                <xsl:apply-templates mode="locatie" select="$ow_gebiedsaanwijzing/../*[local-name()='locatieaanduiding']/*[local-name()='LocatieRef']"/>
                                                                            </xsl:element>
                                                                        </xsl:element>
                                                                    </xsl:element>
                                                                </xsl:element>
                                                            </xsl:for-each>
                                                            <xsl:for-each select="./../../*[local-name()='activiteitaanduiding']">
                                                                <xsl:element name="LI">Activiteitaanduiding: <xsl:element name="UL">
                                                                        <xsl:attribute name="style" select="'background-color:#aaaaaa'"/>
                                                                        <xsl:variable name="activiteit_ref" select="./*[local-name()='ActiviteitRef']/@xlink:href"/>
                                                                        <xsl:element name="LI">Identificatie: <xsl:value-of select="$activiteit_ref"/>
                                                                        </xsl:element>
                                                                        <xsl:apply-templates select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name()='identificatie'][text()=$activiteit_ref]/.." mode="activiteit"/>
                                                                    </xsl:element>
                                                                </xsl:element>
                                                                <xsl:element name="br"/>
                                                            </xsl:for-each>
                                                        </xsl:element>
                                                        <xsl:element name="br"/>
                                                    </xsl:for-each>
                                                </xsl:element>
                                            </xsl:element>
                                            <xsl:element name="br"/>
                                        </xsl:for-each>
                                    </xsl:element>
                                
                            </xsl:element>
                            <xsl:element name="br"/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="." mode="locatie">
        <xsl:variable name="loc_ref" select="./@xlink:href"/>
        <xsl:variable name="ow_locatie" select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name()='identificatie'][text()=$loc_ref]"/>
        <xsl:element name="LI">Identificatie: 
            <xsl:value-of select="$loc_ref"/>
        </xsl:element>
        <xsl:element name="LI">Noemer: 
            <xsl:value-of select="$ow_locatie/../*[local-name()='noemer']" />
        </xsl:element>
    </xsl:template>
    <!-- recursief activiteiten template voor boomstructuur -->
    <xsl:template match="." mode="activiteit">
        <xsl:if test=".!=''">
            <xsl:variable name="activiteit_ref" select="./*[local-name()='identificatie']/text()"/>
            <xsl:element name="LI">Naam: <xsl:value-of select="./*[local-name()='naam']" />
            </xsl:element>
            <xsl:element name="LI">Groep: <xsl:value-of select="./*[local-name()='groep']" />
            </xsl:element>
            <xsl:element name="LI">Locatieaanduiding:<xsl:element name="UL">
                <xsl:attribute name="style" select="'background-color:#707070'"/>
                <xsl:apply-templates mode="locatie" select="./*[local-name()='locatieaanduiding']/*[local-name()='LocatieRef']"/>
            </xsl:element>
            </xsl:element>
            <xsl:variable name="bovenliggend" select="./*[local-name()='bovenliggendeActiviteit']/*[local-name()='ActiviteitRef']/@xlink:href"/>
            <xsl:element name="LI">Bovenliggende activiteit: <xsl:element name="UL">
                    <xsl:element name="LI">Identificatie: <xsl:value-of select="$bovenliggend"/>
                    </xsl:element>
                    <xsl:apply-templates select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name()='identificatie'][text()=$bovenliggend]/.." mode="activiteit"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!-- begin html en haal OP bestand op -->
    <xsl:template match="/">
        <xsl:element name="html" namespace="">
            <xsl:element name="body" namespace="">
                <xsl:element name="UL" namespace="">
                    <xsl:apply-templates mode="list" select="collection(concat($folder, '?select=*.xml;recurse=yes'))/*[local-name()=$OP_root]"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>