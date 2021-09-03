<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:lvbb_intern="http://www.overheid.nl/2020/lvbb/intern" xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:manifest-ow="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"
    xmlns:lvbbu="https://standaarden.overheid.nl/lvbb/stop/uitlevering/" xmlns:foo="http://whatever">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <!-- file.list bevat alle te verwerken bestanden -->

    <xsl:param name="file.list" as="xs:string*"/>
    <xsl:param name="base.dir"/>
    <xsl:param name="alreadyRetrievedDateTime"/>

    <xsl:template match="/">
        <xsl:call-template name="index"/>
    </xsl:template>

    <!-- maak manifest-bestand waarin is aangegeven wat de functie van een bestand is -->

    <xsl:variable name="dateTime" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][h01][m01][s01]')"/>

    <xsl:template name="index">
        <xsl:element name="index">
            <xsl:for-each select="$index/*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!-- stel index-bestand samen -->
    <xsl:param name="index">
        <xsl:element name="dateTime">
            <xsl:value-of select="$dateTime"/>
        </xsl:element>
        <xsl:for-each select="tokenize($file.list, ';')">
            <xsl:variable name="fullname" select="."/>
            <xsl:variable name="pos1" select="position()"/>
            <xsl:if test="document($fullname)/lvbbu:Consolidaties">
                <xsl:element name="consolidatie">
                    <xsl:value-of select="1"/>
                </xsl:element>
            </xsl:if>
            <!-- Doel Id -->
            <!-- Haal oorspronkelijk uit besluit -->
            <!-- BesluitID/RegelingID -->
            <xsl:if test="document($fullname)/aanlevering:AanleveringBesluit">
                <xsl:element name="besluit">
                    <xsl:for-each select="document($fullname)//data:informatieobjectRefs/data:informatieobjectRef">
                        <xsl:element name="informatieobjectRef">
                            <xsl:variable name="oldIoRefId" select="text()"/>
                            <xsl:variable name="oldIoWorkId"
                                select="concat('/', tokenize($oldIoRefId, '/')[2], '/', tokenize($oldIoRefId, '/')[3], '/', tokenize($oldIoRefId, '/')[4], '/', tokenize($oldIoRefId, '/')[5], '/', tokenize($oldIoRefId, '/')[6], '/', tokenize($oldIoRefId, '/')[7])"/>
                            <xsl:for-each select="tokenize($file.list, ';')">
                                <xsl:variable name="giofullname" select="."/>
                                <xsl:for-each select="document($giofullname)//data:FRBRExpression">
                                    <xsl:if test="text() = $oldIoRefId">
                                        <xsl:element name="gio">
                                            <xsl:value-of select="tokenize($giofullname, '/')[last()]"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:for-each>
                            <xsl:for-each select="tokenize($file.list, ';')">
                                <xsl:variable name="gmlfullname" select="."/>
                                <xsl:for-each select="document($gmlfullname)//geo:FRBRExpression">
                                    <xsl:if test="text() = $oldIoRefId">
                                        <xsl:element name="gml">
                                            <xsl:value-of select="tokenize($gmlfullname, '/')[last()]"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:for-each>
                            <xsl:element name="oldIoWorkId">
                                <xsl:value-of select="$oldIoWorkId"/>
                            </xsl:element>
                            <xsl:element name="oldIoRefId">
                                <xsl:value-of select="$oldIoRefId"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <!-- Levering Ids -->
            <xsl:if test="document($fullname)//lvbb_intern:idLevering">
                <xsl:element name="leveringId">
                    <xsl:attribute name="sourcefile" select="tokenize($fullname, '/')[last()]"/>
                    <xsl:for-each select="tokenize($file.list, ';')">
                        <xsl:variable name="referencefullname" select="."/>
                        <xsl:if test="document($referencefullname)//sl:leveringsId">
                            <xsl:element name="referencefile">
                                <xsl:value-of select="tokenize($referencefullname, '/')[last()]"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:element name="new">
                        <xsl:value-of select="concat(document($fullname)//lvbb_intern:idLevering/text(), '-', $dateTime)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:idLevering">
                <xsl:element name="leveringId">
                    <xsl:attribute name="sourcefile" select="tokenize($fullname, '/')[last()]"/>
                    <xsl:for-each select="tokenize($file.list, ';')">
                        <xsl:variable name="referencefullname" select="."/>
                        <xsl:if test="document($referencefullname)//sl:leveringsId">
                            <xsl:element name="referencefile">
                                <xsl:value-of select="tokenize($referencefullname, '/')[last()]"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:element name="new">
                        <xsl:value-of select="concat(document($fullname)//lvbb:idLevering/text(), '-', $dateTime)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <!-- GUIDS -->
            <xsl:if test="document($fullname)//geo:GeoInformatieObjectVaststelling">
                <xsl:element name="guids">
                    <xsl:for-each select="document($fullname)//geo:GeoInformatieObjectVaststelling/descendant::basisgeo:id">
                        <xsl:variable name="pos2" select="position()"/>
                        <xsl:variable name="orgGUID" select="text()"/>
                        <xsl:variable name="locatiefile">
                            <xsl:for-each select="tokenize($file.list, ';')">
                                <xsl:variable name="locatieFile" as="xs:string" select="."/>
                                <xsl:variable name="locatieFileOnly" as="xs:string" select="tokenize($locatieFile, '/')[last()]"/>
                                <xsl:if test="document($locatieFile)//l:GeometrieRef[@xlink:href = $orgGUID]">
                                    <xsl:value-of select="$locatieFileOnly"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="org" select="$orgGUID"/>
                        <xsl:variable name="new" select="foo:generateGuid($pos1 + $pos2)"/>
                        <xsl:variable name="elementName">
                            <xsl:choose>
                                <xsl:when test="not($locatiefile = '')">
                                    <xsl:value-of select="'guidInOw'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'guid'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:element name="{$elementName}">
                            <xsl:attribute name="gmlfile" select="tokenize($fullname, '/')[last()]"/>
                            <xsl:if test="not($locatiefile = '')">
                                <xsl:attribute name="locatiefile" select="$locatiefile"/>
                            </xsl:if>
                            <xsl:element name="org">
                                <xsl:value-of select="$org"/>
                            </xsl:element>
                            <xsl:element name="new">
                                <xsl:value-of select="$new"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($fullname)//basisgeo:FeatureCollectionGeometrie">
                <xsl:element name="guids">
                    <xsl:for-each select="document($fullname)//basisgeo:FeatureCollectionGeometrie/descendant::basisgeo:id">
                        <xsl:variable name="pos2" select="position()"/>
                        <xsl:variable name="orgGUID" select="text()"/>
                        <xsl:variable name="locatiefile">
                            <xsl:for-each select="tokenize($file.list, ';')">
                                <xsl:variable name="locatieFile" as="xs:string" select="."/>
                                <xsl:variable name="locatieFileOnly" as="xs:string" select="tokenize($locatieFile, '/')[last()]"/>
                                <xsl:if test="document($locatieFile)//l:GeometrieRef[@xlink:href = $orgGUID]">
                                    <xsl:value-of select="$locatieFileOnly"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="org" select="$orgGUID"/>
                        <xsl:variable name="new" select="foo:generateGuid($pos1 + $pos2)"/>
                        <xsl:variable name="elementName">
                            <xsl:choose>
                                <xsl:when test="not($locatiefile = '')">
                                    <xsl:value-of select="'guidInOw'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'guid'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:element name="{$elementName}">
                            <xsl:attribute name="gmlfile" select="tokenize($fullname, '/')[last()]"/>
                            <xsl:if test="not($locatiefile = '')">
                                <xsl:attribute name="locatiefile" select="$locatiefile"/>
                            </xsl:if>
                            <xsl:element name="org">
                                <xsl:value-of select="$org"/>
                            </xsl:element>
                            <xsl:element name="new">
                                <xsl:value-of select="$new"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <!-- BESLUIT -->
            <xsl:if test="document($fullname)/aanlevering:AanleveringBesluit">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'besluit.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- OPDRACHT -->
            <xsl:if test="document($fullname)/lvbb:publicatieOpdracht">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'opdracht.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- GML -->
            <xsl:if test="document($fullname)//geo:GeoInformatieObjectVaststelling">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'gml.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- GIO -->
            <xsl:if test="document($fullname)//aanlevering:AanleveringInformatieObject">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'gio.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- OW       -->
            <xsl:if test="document($fullname)//ga:Gebiedsaanwijzing">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'gebiedsaanwijzing.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//k:Kaart">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'kaart.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//k:Kaartlaag">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'kaart.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Ambtsgebied">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Gebied">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Gebiedengroep">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Lijn">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Lijnengroep">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Punt">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Puntengroep">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Locatie">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//p:Pons">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'pons.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rg:Regelingsgebied">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regelingsgebied.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:ActiviteitLocatieaanduiding">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:Regeltekst">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:Instructieregel">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:Omgevingswaarderegel">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:RegelVoorIedereen">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rol:Activiteit">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'activiteit.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rol:Normwaarde">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'normwaarde.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rol:Omgevingswaarde">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'normwaarde.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rol:Omgevingsnorm">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'normwaarde.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//vt:Hoofdlijn">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'hoofdlijn.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//vt:Tekstdeel">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'tekstdeel.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//vt:Divisie">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'vrijetekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'manifest-ow.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:publicatieOpdracht">
                <xsl:element name="file">
                    <xsl:attribute name="type" select="'opdracht.xml'"/>
                    <xsl:attribute name="ow" select="'false'"/>
                    <xsl:element name="fullname">
                        <xsl:value-of select="$fullname"/>
                    </xsl:element>
                    <xsl:element name="name">
                        <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:validatieOpdracht">
                <xsl:element name="file">
                    <xsl:attribute name="type" select="'opdracht.xml'"/>
                    <xsl:attribute name="ow" select="'false'"/>
                    <xsl:element name="fullname">
                        <xsl:value-of select="$fullname"/>
                    </xsl:element>
                    <xsl:element name="name">
                        <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($fullname)//rol:Activiteit/rol:bovenliggendeActiviteit or document($fullname)//rol:Activiteit/rol:gerelateerdeActiviteit">
                <xsl:for-each select="document($fullname)//rol:Activiteit">
                    <xsl:variable name="bovenligendeActiviteitId" select="rol:bovenliggendeActiviteit/rol:ActiviteitRef/@xlink:href"/>
                    <xsl:for-each select="tokenize($file.list, ';')">
                        <xsl:variable name="activiteitBestand" select="."/>
                        <xsl:for-each select="document($activiteitBestand)//rol:Activiteit">
                            <xsl:if test="$bovenligendeActiviteitId = rol:identificatie/text()">
                                <xsl:element name="bovenliggendeActiviteitRelatie">
                                    <xsl:element name="name">
                                        <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                                    </xsl:element>
                                    <xsl:element name="bovenliggendeActiviteitIdLokaalAanwezig">
                                        <xsl:value-of select="$bovenligendeActiviteitId"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:variable name="gerelateerdeActiviteitId" select="rol:gerelateerdeActiviteit/rol:ActiviteitRef/@xlink:href"/>
                    <xsl:for-each select="tokenize($file.list, ';')">
                        <xsl:variable name="activiteitBestand" select="."/>
                        <xsl:for-each select="document($activiteitBestand)//rol:Activiteit">
                            <xsl:if test="$gerelateerdeActiviteitId = rol:identificatie/text()">
                                <xsl:element name="gerelateerdeActiviteitRelatie">
                                    <xsl:element name="name">
                                        <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                                    </xsl:element>
                                    <xsl:element name="gerelateerdeActiviteitIdLokaalAanwezig">
                                        <xsl:value-of select="$gerelateerdeActiviteitId"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:param>

    <xsl:function name="foo:generateGuid">
        <xsl:param name="seed" as="xs:integer"/>
        <xsl:value-of select="translate(translate(translate(unparsed-text(concat('https://uuidgen.org/api/v/4?x=', string($seed))), '[', ''), ']', ''), '&quot;', '')"/>
    </xsl:function>

    <xsl:function name="foo:generateDoelId">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], $dateTime))"
        />
    </xsl:function>

    <xsl:function name="foo:generateFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], $dateTime))"
        />
    </xsl:function>

    <xsl:function name="foo:generateFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], $dateTime), '/', tokenize($oldId, '/')[8])"
        />
    </xsl:function>

    <xsl:template name="references">
        <xsl:param name="orgOWId"/>
        <xsl:for-each select="tokenize($file.list, ';')">
            <xsl:variable name="referencefullname" select="."/>
            <xsl:for-each select="document($referencefullname)//@xlink:href">
                <xsl:if test="$orgOWId = string(.)">
                    <xsl:element name="referencefile">
                        <xsl:value-of select="tokenize($referencefullname, '/')[last()]"/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="file">
        <xsl:param name="type" as="xs:string"/>
        <xsl:param name="fullname" as="xs:string"/>
        <xsl:param name="ow" as="xs:string"/>
        <xsl:element name="file">
            <xsl:attribute name="type" select="$type"/>
            <xsl:attribute name="ow" select="$ow"/>
            <xsl:element name="name">
                <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
