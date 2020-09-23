<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" xmlns:imop="https://standaarden.overheid.nl/lvbb/stop/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ogr="http://ogr.maptools.org/" xmlns:saxon="http://saxon.sf.net/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" xmlns:g="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" xmlns:ga-ref="http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901" xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901" xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901" xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709" xmlns:rkow="http://www.geostandaarden.nl/imow/owobject/v20190709" xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901" xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190901" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/" xmlns:geo_stop="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.overheid.nl/imop/def# ../lvbb/LVBB-stop.xsd" xmlns="https://standaarden.overheid.nl/lvbb/stop/">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <!-- Pad naar het setje bestanden van de opdracht -->
    <xsl:param name="folder" select="'file:///F:/DSO/Geonovum/GitHub/xml_omgevingsplan_gemeentestad_1.0/opdracht'"/>
    <!-- de naam van het root element van het OP bestand -->
    <xsl:param name="OP_root" select="'AanleveringBesluit'"/>
    <!-- functie om het besluit op te halen, compact of klassiek -->
    <xsl:function name="tekst:besluit" as="node()">
        <xsl:param name="input"/>
        <xsl:if test="$input/*[local-name()='BesluitVersie']/*[local-name()='BesluitCompact']">
            <xsl:sequence select="$input/*[local-name()='BesluitVersie']/*[local-name()='BesluitCompact']"/>
        </xsl:if>
        <xsl:if test="$input/*[local-name()='BesluitVersie']/*[local-name()='BesluitKlassiek']">
            <xsl:sequence select="$input/*[local-name()='BesluitVersie']/*[local-name()='BesluitKlassiek']"/>
        </xsl:if>
    </xsl:function>
    <!-- functie om de regeling uit het besluit te halen, compact, tijdelijkdeel, mutatie, vrijetekst -->
    <xsl:function name="tekst:regeling" as="node()">
        <xsl:param name="input"/>
        <!-- RegelingCompact -->
        <xsl:if test="$input/*[local-name()='WijzigBijlage']/*[local-name()='RegelingCompact']">
            <xsl:sequence select="$input/*[local-name()='WijzigBijlage']/*[local-name()='RegelingCompact']"/>
        </xsl:if>
        <!-- RegelingTijdelijkdeel -->
        <xsl:if test="$input/*[local-name()='WijzigBijlage']/*[local-name()='RegelingTijdelijkdeel']">
            <xsl:sequence select="$input/*[local-name()='WijzigBijlage']/*[local-name()='RegelingTijdelijkdeel']"/>
        </xsl:if>
        <!-- RegelingMutatie -->
        <xsl:if test="$input/*[local-name()='WijzigBijlage']/*[local-name()='RegelingMutatie']">
            <xsl:sequence select="$input/*[local-name()='WijzigBijlage']/*[local-name()='RegelingMutatie']"/>
        </xsl:if>
        <!-- RegelingVrijetekst -->
        <xsl:if test="$input/*[local-name()='WijzigBijlage']/*[local-name()='RegelingVrijetekst']">
            <xsl:sequence select="$input/*[local-name()='WijzigBijlage']/*[local-name()='RegelingVrijetekst']"/>
        </xsl:if>
    </xsl:function>

    <!-- begin html en haal OP bestand op -->
    <xsl:template match="/">
        <xsl:element name="html" namespace="">
            <xsl:element name="head" inherit-namespaces="yes" namespace="">
                <xsl:element name="link" inherit-namespaces="yes" namespace="">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="type">text/css</xsl:attribute>
                    <xsl:attribute name="href">F:\DSO\Geonovum\GitHub\xml_xslt\Opdracht_overzicht\Opdracht_overzicht.css</xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:element name="body" namespace="">
                <xsl:element name="UL" namespace="">
                    <xsl:apply-templates mode="list" select="collection(concat($folder, '?select=*.xml;recurse=yes'))/*[local-name()=$OP_root]"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- template voor op bestand -->
    <xsl:template match="." mode="list">
        <xsl:variable name="besluit" select="tekst:besluit(.)"/>
        <xsl:variable name="regeling" select="tekst:regeling($besluit)"/>
        <!-- Naam van root element -->
        <xsl:element name="LI" inherit-namespaces="yes" namespace="">
            <xsl:attribute name="class">kop</xsl:attribute>
            <xsl:value-of select="./local-name()"/>
        </xsl:element>
        <xsl:element name="LI" inherit-namespaces="yes" namespace="">
            <xsl:attribute name="class">list</xsl:attribute>BesluitVersie
        </xsl:element>
        
            <!-- ExpressionIdentificatie -->
            <xsl:apply-templates select="./*[local-name()='BesluitVersie']" mode="ExpressionIdentificatie"/>
            
            <!-- BesluitMetadata -->
            <xsl:variable name="BesluitMetadata" select="./*[local-name()='BesluitVersie']/*[local-name()='BesluitMetadata']"/>
            <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                    <xsl:attribute name="class">sublist</xsl:attribute>BesluitMetadata:</xsl:element>
                <xsl:element name="TABLE" inherit-namespaces="yes" namespace="">
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">eindverantwoordelijke: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:value-of select="$BesluitMetadata/*[local-name()='eindverantwoordelijke']"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">maker: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:value-of select="$BesluitMetadata/*[local-name()='maker']"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">officieleTitel: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:value-of select="$BesluitMetadata/*[local-name()='officieleTitel']"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">informatieobjectRefs: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:for-each select="$BesluitMetadata/*[local-name()='informatieobjectRefs']/*[local-name()='informatieobjectRef']">
                                <xsl:element name="PRE" inherit-namespaces="yes" namespace="">
                                    <xsl:value-of select="concat(./text(),'&#13;&#10;')"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <!-- Procedureverloop -->
            <xsl:variable name="Procedureverloop" select="./*[local-name()='BesluitVersie']/*[local-name()='Procedureverloop']"/>
            <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                    <xsl:attribute name="class">sublist</xsl:attribute>Procedureverloop</xsl:element>
                <xsl:element name="TABLE" inherit-namespaces="yes" namespace="">
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">bekendOp: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:value-of select="$Procedureverloop/*[local-name()='bekendOp']"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">ontvangenOp: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:value-of select="$Procedureverloop/*[local-name()='ontvangenOp']"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">procedurestappen: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:element name="TABLE" inherit-namespaces="yes" namespace="">
                                <xsl:for-each select="$Procedureverloop/*[local-name()='procedurestappen']/*[local-name()='Procedurestap']">
                                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">soortStap:</xsl:element>
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                            <xsl:attribute name="class">art_cell</xsl:attribute>
                                            <xsl:value-of select="./*[local-name()='soortStap']"/>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">voltooidOp:</xsl:element>
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                            <xsl:attribute name="class">art_cell</xsl:attribute>
                                            <xsl:value-of select="./*[local-name()='voltooidOp']"/>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">actor:</xsl:element>
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                            <xsl:attribute name="class">art_cell</xsl:attribute>
                                            <xsl:value-of select="./*[local-name()='actor']"/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <!-- ConsolidatieInformatie -->
            <xsl:variable name="ConsolidatieInformatie" select="./*[local-name()='BesluitVersie']/*[local-name()='ConsolidatieInformatie']"/>
            <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                    <xsl:attribute name="class">sublist</xsl:attribute>ConsolidatieInformatie</xsl:element>
                <!-- BeoogdeRegeling -->
                <xsl:element name="LI" inherit-namespaces="yes" namespace="">BeoogdeRegelgeving<xsl:element name="UL" inherit-namespaces="yes" namespace="">
                    <xsl:attribute name="class">orderlist</xsl:attribute>
                    <!-- BeoogdeRegeling, BeoogdInformatieobject  -->
                    <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                        <xsl:attribute name="class">art_cell</xsl:attribute>
                        <xsl:element name="TABLE" inherit-namespaces="yes" namespace="">
                            <xsl:for-each select="$ConsolidatieInformatie/*[local-name()='BeoogdeRegelgeving']/child::*">
                                <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                        <xsl:value-of select="./local-name()"/>
                                    </xsl:element>
                                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">doel:</xsl:element>
                                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                        <xsl:attribute name="class">art_cell</xsl:attribute>
                                        <xsl:value-of select="./*[local-name()='doelen']//text()" />
                                    </xsl:element>
                                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace=""/>
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">instrumentVersie:</xsl:element>
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                            <xsl:attribute name="class">art_cell</xsl:attribute>
                                            <xsl:value-of select="./*[local-name()='instrumentVersie']//text()" />
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace=""/>
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">eId:</xsl:element>
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                            <xsl:attribute name="class">art_cell</xsl:attribute>
                                            <xsl:value-of select="./*[local-name()='eId']//text()" />
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                </xsl:element>
                <xsl:element name="LI" inherit-namespaces="yes" namespace="">Tijdstempels<xsl:element name="UL" inherit-namespaces="yes" namespace="">
                    <xsl:attribute name="class">orderlist</xsl:attribute>
                    <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                        <xsl:attribute name="class">art_cell</xsl:attribute>
                        <xsl:element name="TABLE" inherit-namespaces="yes" namespace="">
                            <xsl:for-each select="./*[local-name()='BesluitVersie']/*[local-name()='ConsolidatieInformatie']/*[local-name()='Tijdstempels']">
                                <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">Doel:</xsl:element>
                                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                        <xsl:attribute name="class">art_cell</xsl:attribute>
                                        <xsl:value-of select="./*[local-name()='Tijdstempel']/*[local-name()='doel']//text()" />
                                    </xsl:element>
                                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">Soort:</xsl:element>
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                            <xsl:attribute name="class">art_cell</xsl:attribute>
                                            <xsl:value-of select="./*[local-name()='Tijdstempel']/*[local-name()='soortTijdstempel']//text()" />
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">Datum:</xsl:element>
                                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                            <xsl:attribute name="class">art_cell</xsl:attribute>
                                            <xsl:value-of select="./*[local-name()='Tijdstempel']/*[local-name()='datum']//text()" />
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                </xsl:element>
            </xsl:element>
            <!-- BesluitCompact of BesluitKlassiek -->
            <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                    <xsl:attribute name="class">sublist</xsl:attribute>
                    <xsl:value-of select="$besluit/[local-name()]"/>
                </xsl:element>
                <xsl:element name="TABLE" inherit-namespaces="yes" namespace="">
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">RegelingOpschrift: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:apply-templates select="$besluit/*[local-name()='RegelingOpschrift']" mode="Art_text"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">Aanhef: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:apply-templates select="$besluit/*[local-name()='Aanhef']" mode="Art_text"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:for-each select="$besluit/*[local-name()='Lichaam']/child::*">
                        <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                            <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                <xsl:value-of select="concat(./*[local-name()='Kop']/*[local-name()='Label']/text(),' ',./*[local-name()='Kop']/*[local-name()='Nummer']/text())"/>
                                <xsl:value-of select="concat(' (',./local-name(),')&#13;&#10;')"/>
                            </xsl:element>
                            <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                <xsl:attribute name="class">art_cell</xsl:attribute>
                                <xsl:apply-templates select="." mode="Art_text"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">Sluiting: </xsl:element>
                        <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                            <xsl:attribute name="class">art_cell</xsl:attribute>
                            <xsl:apply-templates select="$besluit/*[local-name()='Sluiting']" mode="Art_text"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <!-- Regeling -->
            <xsl:element name="DL" inherit-namespaces="yes" namespace="">
                <xsl:attribute name="class">deflist</xsl:attribute>
                <xsl:element name="DT" inherit-namespaces="yes" namespace="">
                    <xsl:attribute name="class">list</xsl:attribute>
                    <xsl:value-of select="$regeling/[local-name()]"/>:<xsl:element name="DD">
                        <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Componentnaam: <xsl:element name="FONT">
                                <xsl:attribute name="style" select="'font-weight:bold'"/>
                                <xsl:value-of select="$regeling/@componentnaam" />
                            </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Wordt: <xsl:element name="FONT">
                                <xsl:attribute name="style" select="'font-weight:bold'"/>
                                <xsl:value-of select="$regeling/@wordt" />
                            </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                            <xsl:variable name="opschrift" select="$regeling/*[local-name()='RegelingOpschrift']/*[local-name()='Al']/text()"/>
                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Opschrift: <xsl:element name="FONT">
                                <xsl:attribute name="style" select="'font-weight:bold'"/>
                                <xsl:value-of select="$opschrift" />
                            </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        <!-- Conditie, Hoofdstuk, Vervang, ... en Artikelen -->
                        <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                                <xsl:attribute name="class">sublist</xsl:attribute>Artikelen
                            </xsl:element>
                            <xsl:apply-templates select="$regeling/*[local-name()='Lichaam']/child::*" mode="structuur"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        
        <!-- RegelingVersieInformatie -->
        <xsl:apply-templates select="./*[local-name()='RegelingVersieInformatie']" mode="RegelingVersieInformatie"/>
        
    </xsl:template>
    
    <!-- template voor ExpressionIdentificatie -->
    <xsl:template match="." mode="ExpressionIdentificatie">
        <xsl:element name="UL" inherit-namespaces="yes" namespace="">
            <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                <xsl:attribute name="class">sublist</xsl:attribute>ExpressionIdentificatie:
            </xsl:element>
            <xsl:element name="TABLE" inherit-namespaces="yes" namespace="">
                <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">FRBRWork: 
                    </xsl:element>
                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                        <xsl:value-of select="./*[local-name()='ExpressionIdentificatie']/*[local-name()='FRBRWork']"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">FRBRExpression: 
                    </xsl:element>
                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                        <xsl:value-of select="./*[local-name()='ExpressionIdentificatie']/*[local-name()='FRBRExpression']"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">soortWork: 
                    </xsl:element>
                    <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                        <xsl:value-of select="./*[local-name()='ExpressionIdentificatie']/*[local-name()='soortWork']"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- Artikel tekst opmaak -->
    <xsl:template match="." mode="Art_text">
        <xsl:element name="PRE" inherit-namespaces="yes" namespace="">
            <xsl:for-each select=".//*[local-name()='Al']">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
                <xsl:value-of select="'&#13;&#10;'"/>
            </xsl:for-each>
            <xsl:for-each select=".//*[local-name()='Wat']">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match=".[local-name()='IntIoRef']" mode="IntIoRef">
        <xsl:element name="b">
            <xsl:element name="ins">
                <xsl:value-of select="./text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="sup">
            <xsl:element name="ins">
                <xsl:value-of select="concat('(',./@eId,'|',./@wId,'|', ./@ref,') ')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match=".[local-name()='ExtIoRef']" mode="ExtIoRef">
        <xsl:element name="b">
            <xsl:element name="ins">
                <xsl:value-of select="./text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="sup">
            <xsl:value-of select="concat('(',./@eId,'|',./@wId,'|', ./@ref,') ')"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match=".[local-name()='IntRef']" mode="IntRef">
        <xsl:element name="b">
            <xsl:element name="ins">
                <xsl:value-of select="./text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="sup">
            <xsl:element name="ins">
                <xsl:value-of select="concat('(', ./@ref,') ')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- Alles onder Lichaam, kop plaatsen en volgende niveau tot Artikel -->
    <xsl:template match=".[local-name()='Hoofdstuk' or local-name()='Afdeling']" mode="structuur">
        <xsl:element name="UL" inherit-namespaces="yes" namespace="">        
            <xsl:element name="LI" inherit-namespaces="yes" namespace="">
            <xsl:value-of select="concat(./local-name(),' ',././*[local-name()='Kop']/*[local-name()='Nummer']/text(),' ',' - ',././*[local-name()='Kop']/*[local-name()='Opschrift']/text())"/>
        </xsl:element>
        <xsl:apply-templates select="./child::*[local-name()!='Kop']" mode="structuur"/>
        </xsl:element>
    </xsl:template>
    
    <!-- Artikel -->
    <xsl:template match=".[local-name()='Artikel']" mode="structuur">
        <xsl:element name="UL" inherit-namespaces="yes" namespace="">
            <xsl:variable name="zoek_wId" select="./@wId"/>
            <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                <xsl:value-of select="./*[local-name()='Kop']/*[local-name()='Label']/text()" />: <xsl:value-of select="./*[local-name()='Kop']/*[local-name()='Nummer']/text()" /> - <xsl:value-of select="./*[local-name()='Kop']/*[local-name()='Opschrift']/text()" />
                <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                    <xsl:element name="LI" inherit-namespaces="yes" namespace="">wId: <xsl:value-of select="$zoek_wId"/>
                    </xsl:element>
                    <!-- TODO: Gereserveerd, Inhoud, Lid of Vervallen -->
                    <xsl:for-each select="./*[local-name()!='Kop']">
                        <xsl:element name="TABLE" inherit-namespaces="yes" namespace="">
                            <xsl:element name="TR" inherit-namespaces="yes" namespace="">
                                <xsl:element name="TD" inherit-namespaces="yes" namespace="">Inhoud: </xsl:element>
                                <xsl:element name="TD" inherit-namespaces="yes" namespace="">
                                    <xsl:attribute name="class">art_cell</xsl:attribute>
                                    <xsl:apply-templates select="." mode="Art_text"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                    <!--Inhoud: <xsl:value-of select=".//*[local-name()='Inhoud']"/>-->
                    <!-- Regelteksten -->
                    <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                        <xsl:attribute name="class" select="'regeltekst_list'"/>Regeltekst(en): 
                    </xsl:element>
                    <xsl:variable name="ow_regeltekst" select="collection(concat($folder, '?select=*.xml;recurse=yes'))[root()/element()//*[local-name()='objectType']='Regeltekst']"/>
                        <xsl:for-each select="$ow_regeltekst/root()/element()//*[contains(@wId,$zoek_wId)]/*[local-name()='identificatie']">
                            <xsl:variable name="regel_id" select="./text()"/>
                            <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                                <xsl:attribute name="class" select="'regeltekst'"/>
                                <xsl:element name="LI" inherit-namespaces="yes" namespace="">Regeltekst: <xsl:value-of select="$regel_id"/>
                                    <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                                        <xsl:element name="LI" inherit-namespaces="yes" namespace="">
                                            <xsl:for-each select="$ow_regeltekst/root()/element()//*[@xlink:href=$regel_id]/../..">Juridische regel: <xsl:value-of select="./local-name()"/>
                                                <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                                                    <xsl:element name="LI" inherit-namespaces="yes" namespace="">Identificatie: <xsl:value-of select="./*[local-name()='identificatie']/text()"/>
                                                    </xsl:element>
                                                    <xsl:for-each select="./*[local-name()='locatieaanduiding']">
                                                        <xsl:element name="LI" inherit-namespaces="yes" namespace="">Locatieaanduiding:<xsl:element name="UL" inherit-namespaces="yes" namespace="">
                                                            <xsl:attribute name="style" select="'background-color:#707070'"/>
                                                            <xsl:apply-templates mode="locatie" select="./*[local-name()='LocatieRef']"/>
                                                        </xsl:element>
                                                        </xsl:element>
                                                    </xsl:for-each>
                                                    <xsl:for-each select="./*[local-name()='gebiedsaanwijzing']">
                                                        <xsl:element name="LI" inherit-namespaces="yes" namespace="">Gebiedsaanwijzing:<xsl:element name="UL" inherit-namespaces="yes" namespace="">
                                                            <xsl:attribute name="style" select="'background-color:#909090'"/>
                                                            <xsl:variable name="gebiedsaanwijzing_ref" select="./*[local-name()='GebiedsaanwijzingRef']/@xlink:href"/>
                                                            <xsl:variable name="ow_gebiedsaanwijzing" select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name()='identificatie'][text()=$gebiedsaanwijzing_ref]"/>
                                                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Identificatie: <xsl:value-of select="$gebiedsaanwijzing_ref"/>
                                                            </xsl:element>
                                                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Type: <xsl:value-of select="$ow_gebiedsaanwijzing/../*[local-name()='type']" />
                                                            </xsl:element>
                                                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Naam: <xsl:value-of select="$ow_gebiedsaanwijzing/../*[local-name()='naam']" />
                                                            </xsl:element>
                                                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Locatieaanduiding: <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                                                                <xsl:attribute name="style" select="'background-color:#707070'"/>
                                                                <xsl:apply-templates mode="locatie" select="$ow_gebiedsaanwijzing/../*[local-name()='locatieaanduiding']/*[local-name()='LocatieRef']"/>
                                                            </xsl:element>
                                                            </xsl:element>
                                                        </xsl:element>
                                                        </xsl:element>
                                                    </xsl:for-each>
                                                    <xsl:for-each select="./*[local-name()='activiteitaanduiding']">
                                                        <xsl:element name="LI" inherit-namespaces="yes" namespace="">Activiteitaanduiding: <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                                                            <xsl:attribute name="style" select="'background-color:#aaaaaa'"/>
                                                            <xsl:variable name="activiteit_ref" select="./*[local-name()='ActiviteitRef']/@xlink:href"/>
                                                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Identificatie: <xsl:value-of select="$activiteit_ref"/>
                                                            </xsl:element>
                                                            <xsl:apply-templates select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name()='identificatie'][text()=$activiteit_ref]/.." mode="activiteit"/>
                                                            <xsl:element name="LI" inherit-namespaces="yes" namespace="">ActiviteitLocatieaanduiding: <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                                                                <xsl:element name="LI" inherit-namespaces="yes" namespace="">Identificatie: <xsl:value-of select="./*[local-name()='ActiviteitLocatieaanduiding']/*[local-name()='identificatie']/text()"/>
                                                                </xsl:element>
                                                                <xsl:element name="LI" inherit-namespaces="yes" namespace="">Activiteitregelkwalificatie: <xsl:value-of select="./*[local-name()='ActiviteitLocatieaanduiding']/*[local-name()='activiteitregelkwalificatie']/text()"/>
                                                                </xsl:element>
                                                                <xsl:element name="LI" inherit-namespaces="yes" namespace="">Locatieaanduiding:<xsl:element name="UL" inherit-namespaces="yes" namespace="">
                                                                    <xsl:attribute name="style" select="'background-color:#707070'"/>
                                                                    <xsl:apply-templates mode="locatie" select="./*[local-name()='ActiviteitLocatieaanduiding']/*[local-name()='locatieaanduiding']/*[local-name()='LocatieRef']"/>
                                                                </xsl:element>
                                                                </xsl:element>
                                                            </xsl:element>
                                                            </xsl:element>
                                                        </xsl:element>
                                                        </xsl:element>
                                                        <xsl:element name="br" inherit-namespaces="yes" namespace=""/>
                                                    </xsl:for-each>
                                                </xsl:element>
                                                <xsl:element name="br" inherit-namespaces="yes" namespace=""/>
                                            </xsl:for-each>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="br" inherit-namespaces="yes" namespace=""/>
                        </xsl:for-each>
                    
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- locatie -->
    <xsl:template match="." mode="locatie">
        <xsl:variable name="loc_ref" select="./@xlink:href"/>
        <xsl:variable name="ow_locatie" select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name()='identificatie'][text()=$loc_ref]"/>
        <xsl:element name="LI" inherit-namespaces="yes" namespace="">Identificatie: <xsl:value-of select="$loc_ref"/>
        </xsl:element>
        <xsl:element name="LI" inherit-namespaces="yes" namespace="">Noemer: <xsl:value-of select="$ow_locatie/../*[local-name()='noemer']" />
        </xsl:element>
    </xsl:template>
    
    <!-- recursief activiteiten template voor boomstructuur -->
    <xsl:template match="." mode="activiteit">
        <xsl:if test=".!=''">
            <xsl:variable name="activiteit_ref" select="./*[local-name()='identificatie']/text()"/>
            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Naam: <xsl:value-of select="./*[local-name()='naam']" />
            </xsl:element>
            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Groep: <xsl:value-of select="./*[local-name()='groep']" />
            </xsl:element>
            <xsl:variable name="bovenliggend" select="./*[local-name()='bovenliggendeActiviteit']/*[local-name()='ActiviteitRef']/@xlink:href"/>
            <xsl:element name="LI" inherit-namespaces="yes" namespace="">Bovenliggende activiteit: <xsl:element name="UL" inherit-namespaces="yes" namespace="">
                <xsl:element name="LI" inherit-namespaces="yes" namespace="">Identificatie: <xsl:value-of select="$bovenliggend"/>
                </xsl:element>
                <xsl:apply-templates select="collection(concat($folder, '?select=*.xml;recurse=yes'))/root()/element()//*[local-name()='identificatie'][text()=$bovenliggend]/.." mode="activiteit"/>
            </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <!-- RegelingVersieInformatie -->
    <xsl:template match="." mode="RegelingVersieInformatie">
        <xsl:element name="LI">
            <xsl:attribute name="class">list</xsl:attribute>RegelingVersieInformatie
        </xsl:element>
        <!-- ExpressionIdentificatie -->
        <xsl:apply-templates select="." mode="ExpressionIdentificatie"/>
        <!-- RegelingVersieMetadata -->
        <xsl:element name="UL">
            <xsl:element name="LI">
                <xsl:attribute name="class">sublist</xsl:attribute>RegelingVersieMetadata
            </xsl:element>
            <xsl:element name="TABLE">
                <xsl:apply-templates select="./*[local-name()='RegelingVersieMetadata']/child::*" mode="kinderen"></xsl:apply-templates>
            </xsl:element>
        </xsl:element>
        <!-- RegelingMetadata -->
        <xsl:element name="UL">
            <xsl:element name="LI">
                <xsl:attribute name="class">sublist</xsl:attribute>RegelingMetadata
            </xsl:element>
            <xsl:element name="TABLE">
                <xsl:apply-templates select="./*[local-name()='RegelingMetadata']/child::*" mode="kinderen"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- Alle kinderen van een element in rijen van een tabel -->
    <xsl:template match="." mode="kinderen">
            <xsl:element name="TR">
                <xsl:element name="TD">
                    <xsl:value-of select="concat(./[local-name()],': ')"/>
                </xsl:element>
                <xsl:element name="TD">
                    <xsl:if test="*">
                        <xsl:element name="TABLE">
                            <xsl:apply-templates select="./child::*" mode="kinderen"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:value-of select="./text()"/>
                </xsl:element>
            </xsl:element>
    </xsl:template>
</xsl:stylesheet>