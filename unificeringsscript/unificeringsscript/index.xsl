<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:foo="http://whatever">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <!-- file.list bevat alle te verwerken bestanden -->

    <xsl:param name="file.list" as="xs:string*"/>
    <xsl:param name="base.dir"/>

    <xsl:template match="/">
        <xsl:call-template name="index"/>
    </xsl:template>

    <!-- maak manifest-bestand waarin is aangegeven wat de functie van een bestand is -->

    <xsl:template name="index">
        <xsl:element name="index">
            <xsl:for-each select="$index/*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!-- stel index-bestand samen -->
    <xsl:param name="index">
        <xsl:message select="$file.list"/>
        <xsl:variable name="pos1" select="position()"/>
        <xsl:for-each select="tokenize($file.list, ';')">
            <xsl:variable name="fullname" select="."/>
            <xsl:choose>
                <!-- GML -->
                <xsl:when test="document($fullname)//geo:GeoInformatieObjectVaststelling">
                    <xsl:element name="guids" >
                        <xsl:attribute name="gmlfile" select="tokenize($fullname, '/')[last()]"/>
                        <xsl:for-each select="document($fullname)//geo:GeoInformatieObjectVaststelling/descendant::basisgeo:id">
                            <xsl:variable name="pos2" select="position()"/>
                            <xsl:element name="guid">
                                <xsl:element name="org">
                                    <xsl:value-of select="text()"/>
                                </xsl:element>
                                <xsl:element name="new">
                                    <xsl:value-of select="foo:generateGuid($pos1 + $pos2)"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <!-- BESLUIT -->
                <xsl:when test="document($fullname)/aanlevering:AanleveringBesluit">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('besluit.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <!-- OPDRACHT -->
                <xsl:when test="document($fullname)/lvbb:publicatieOpdracht">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('opdracht.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <!-- GML -->
                <xsl:when test="document($fullname)//geo:GeoInformatieObjectVaststelling">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('gml.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                        <xsl:element name="guids">
                            <xsl:for-each select="document($fullname)//geo:GeoInformatieObjectVaststelling/descendant::basisgeo:id">
                                <xsl:variable name="pos2" select="position()"/>
                                <xsl:element name="guid">
                                    <xsl:element name="org">
                                        <xsl:value-of select="text()"/>
                                    </xsl:element>
                                    <xsl:element name="new">
                                        <xsl:value-of select="foo:generateGuid($pos1 + $pos2)"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <!-- GIO -->
                <xsl:when test="document($fullname)//aanlevering:AanleveringInformatieObject">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('gio.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <!-- OW       -->
                <xsl:when test="document($fullname)//r:Regeltekst">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('regeltekst.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//vt:Divisie">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('vrijetekst.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//rol:Activiteit">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('activiteit.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//ga:Gebiedsaanwijzing">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('gebiedsaanwijzing.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//rol:Normwaarde">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('normwaarde.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//l:Gebied">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('locatie.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                        <xsl:element name="guids">
                            <xsl:for-each select="document($fullname)//l:Gebied/descendant::l:GeometrieRef">
                                <xsl:element name="guid">
                                    <xsl:element name="org">
                                        <xsl:value-of select="@xlink:href"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//l:Gebiedengroep">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('locatie.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//l:Lijn">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('locatie.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                        <xsl:element name="guids">
                            <xsl:for-each select="document($fullname)//l:Lijn/descendant::l:GeometrieRef">
                                <xsl:element name="guid">
                                    <xsl:element name="org">
                                        <xsl:value-of select="@xlink:href"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//l:Lijnengroep">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('locatie.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//l:Punt">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('locatie.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                        <xsl:element name="guids">
                            <xsl:for-each select="document($fullname)//l:Punt/descendant::l:GeometrieRef">
                                <xsl:element name="guid">
                                    <xsl:element name="org">
                                        <xsl:value-of select="@xlink:href"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//l:Puntengroep">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('locatie.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//l:Locatie">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('locatie.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                        <xsl:element name="guids">
                            <xsl:for-each select="document($fullname)//l:Locatie/descendant::l:GeometrieRef">
                                <xsl:element name="guid">
                                    <xsl:element name="org">
                                        <xsl:value-of select="@xlink:href"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//p:Pons">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('pons.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//k:Kaart">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('kaart.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//rg:Regelingsgebied">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('regelingsgebied.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//vt:Hoofdlijn">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('hoofdlijn.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="document($fullname)//Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
                    <xsl:element name="file">
                        <xsl:attribute name="type" select="string('manifest_ow.xml')"/>
                        <xsl:element name="fullname">
                            <xsl:value-of select="$fullname"/>
                        </xsl:element>
                        <xsl:element name="name">
                            <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:param>

    <xsl:function name="foo:generateGuid">
        <xsl:param name="seed" as="xs:integer"/>
        <xsl:value-of
            select="
                translate(
                translate(
                translate(
                unparsed-text(
                concat('https://uuidgen.org/api/v/4?x=', string($seed)
                )
                ), '[', ''
                ), ']', ''
                ), '&quot;', '')"
        />
    </xsl:function>


</xsl:stylesheet>
