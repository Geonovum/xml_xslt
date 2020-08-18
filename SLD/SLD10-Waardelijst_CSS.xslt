<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"  
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    exclude-result-prefixes="xs xd math"  
    version="2.0">
    <xsl:output method="text" encoding="UTF-8" indent="yes"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Aug 18, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> W10_admin</xd:p>
            <xd:p>Van SLD naar CSS voor de waardelijst</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:text>
waardelijsten {
    font-family: arial;
    color: black;
    width: 100%;
    margin-left: 40px;
    }

waardelijsten:before{
    color: white;
    font-weight: 400;
    font-size:21px;
    line-height: 33.9833px;
    background-color: #39870c;
    content:'IMOW waardelijsten'
    }

waardelijst, waardelijst label {
    display: block;
    margin-left: 10px;
    }

waardelijst label {
    color: white;
    font-family: arial;
    font-weight: 400;
    background-color: rgb(137, 137, 137);
    }

titel, uri, type, omschrijving, toelichting, waarden{
    display:block;
    margin-left: 20px
    }

waarden waarde, waarde label{
    display:block;
    margin-left: 20px;
    }

waarde label{
    color:black;
    background-color: rgb(229, 229, 229);
    }

term, waarde uri, definitie, waarde toelichting, bron, domein, symboolcode{
    display:block;
    margin-left: 30px
    }

symboolcode::before {
    content: 'Symboolcode: '
    }
        </xsl:text>
        <xsl:apply-templates select="//*[local-name()='Rule']"/>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="." >
        <xsl:variable name="symboolcode" select="./*[local-name()='Name']"/>
        <xsl:variable name="border-width" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-width']/text()"/>
        <xsl:variable name="border-color" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke']/text()"/>
        <xsl:variable name="border-opacity" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-opacity']/text()"/>
        <xsl:variable name="image_url" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'GraphicFill']/*[local-name() = 'Graphic']/*[local-name() = 'ExternalGraphic']/*[local-name() = 'OnlineResource']/@xlink:href"/>
        <xsl:text>&#xa;symboolcode[id='</xsl:text>
        <xsl:value-of select="$symboolcode"/>
        <xsl:text>']::after{</xsl:text> 
        <xsl:text>&#xa;&#x9;content:'\00A0 \00A0 \00A0 \00A0 \00A0 \00A0 \00A0 \00A0 \00A0';</xsl:text>
        <xsl:text>&#xa;&#x9;line-height: 40px;</xsl:text>
        <xsl:text>&#xa;&#x9;font-size: 30px;</xsl:text>
        <xsl:text>&#xa;&#x9;margin: 10px;</xsl:text>
        <!-- image of vlakvulling -->
        <xsl:choose>
            <xsl:when test="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'GraphicFill']/*[local-name() = 'Graphic']/*[local-name() = 'ExternalGraphic']/*[local-name() = 'OnlineResource']/@xlink:href">
                <xsl:text>&#xa;&#x9;background-image:url('</xsl:text>
                <xsl:value-of select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'GraphicFill']/*[local-name() = 'Graphic']/*[local-name() = 'ExternalGraphic']/*[local-name() = 'OnlineResource']/@xlink:href"/>
                <xsl:text>');</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="background-color" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill']/text()"/>
                <xsl:variable name="background-opacity" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill-opacity']/text()"/>
                <xsl:text>&#xa;&#x9;background-color: rgba(</xsl:text>
                <xsl:call-template name="hex2num">
                    <xsl:with-param name="hex">
                        <xsl:value-of select="fn:substring($background-color, 2, 2)"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:text>,</xsl:text>
                <xsl:call-template name="hex2num">
                    <xsl:with-param name="hex">
                        <xsl:value-of select="fn:substring($background-color, 4, 2)"/>
                    </xsl:with-param></xsl:call-template>
                <xsl:text>,</xsl:text>
                <xsl:call-template name="hex2num">
                    <xsl:with-param name="hex">
                        <xsl:value-of select="fn:substring($background-color, 6, 2)"/>
                    </xsl:with-param></xsl:call-template>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="$background-opacity"/>
                <xsl:text>);</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xa;&#x9;border-width:</xsl:text>
        <xsl:value-of select="$border-width"/>
        <xsl:text>px;</xsl:text>
        <xsl:text>&#xa;&#x9;border-color: </xsl:text>
        <xsl:value-of select="$border-color"/>
        <xsl:text>;</xsl:text>
        <!-- controleren op waarde bij stroke-dasharray; er is geen mogelijkheid in CSS om de dasharray in te stellen, alleen een standaard 'dashed' -->
        <xsl:choose>
            <xsl:when test="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-dasharray']/text()">
                <xsl:text>&#xa;&#x9;border-style: dashed;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#xa;&#x9;border-style: solid;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xa;&#x9;}</xsl:text>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="hex"/>
        <xd:param name="num"/>
        <xd:param name="MSB"/>
        <xd:param name="value"/>
        <xd:param name="result"/>
    </xd:doc>
    <xsl:template name="hex2num">
        <xsl:param name="hex"/>
        <xsl:param name="num" select="0"/>
        <xsl:param name="MSB" select="translate(substring($hex, 1, 1), 'abcdef', 'ABCDEF')"/>
        <xsl:param name="value" select="string-length(substring-before('0123456789ABCDEF', $MSB))"/>
        <xsl:param name="result" select="16 * $num + $value"/>
        <xsl:choose>
            <xsl:when test="string-length($hex) > 1">
                <xsl:call-template name="hex2num">
                    <xsl:with-param name="hex" select="substring($hex, 2)"/>
                    <xsl:with-param name="num" select="$result"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$result"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>