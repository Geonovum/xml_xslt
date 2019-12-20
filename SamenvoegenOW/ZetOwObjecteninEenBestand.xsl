<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output encoding="UTF-8"></xsl:output>

    <xsl:template match="/">
        <xsl:result-document href="OwTotaal.xml">
        <owBestand xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301"
            xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901"
            xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901"
            xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709"
            xmlns:ow="http://www.geostandaarden.nl/imow/owobject/v20190709"
            xmlns="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901"
            xsi:schemaLocation="http://www.geostandaarden.nl/imow/0.98.1 https://raw.githubusercontent.com/Geonovum/xml_ow_xsd_0.98.1-kern/master/xsd/bestanden-ow/deelbestand-ow/v20190901/IMOW_Deelbestand_v0_9_8_2.xsd">
            <xsl:element name="sl:standBestand">
                <xsl:variable name="documents"
                    select="document('manifest-ow.xml')//Modules/RegelingVersie/Bestand/naam"/>
                <xsl:element name="sl:dataset">
                    <xsl:value-of select="document($documents[1])//sl:standBestand/sl:dataset"/>
                </xsl:element>
                <xsl:element name="sl:inhoud">
                    <xsl:element name="sl:gebied">
                        <xsl:value-of
                            select="document($documents[1])//sl:standBestand/sl:inhoud/sl:gebied"/>
                    </xsl:element>
                    <xsl:element name="sl:leveringsId">
                        <xsl:value-of
                            select="document($documents[1])//sl:standBestand/sl:inhoud/sl:leveringsId"
                        />
                    </xsl:element>
                    <xsl:element name="sl:objectTypen">
                        <xsl:for-each
                            select="document('manifest-ow.xml')//Modules/RegelingVersie/Bestand/naam">
                            <xsl:variable name="filename" select="."/>
                            <xsl:variable name="objectTypes"
                                select="document($filename)//sl:standBestand/sl:inhoud/sl:objectTypen/sl:objectType"/>
                            <xsl:for-each select="distinct-values($objectTypes)">
                                <xsl:element name="sl:objectType">
                                    <xsl:value-of select="."/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
                <xsl:for-each
                    select="document('manifest-ow.xml')//Modules/RegelingVersie/Bestand/naam">
                    <xsl:variable name="filename" select="."/>
                    <xsl:for-each select="document($filename)//sl:standBestand/sl:stand">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
        </owBestand>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
