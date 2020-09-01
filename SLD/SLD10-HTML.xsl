<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
    xmlns:xs="http://www.w3.org/2001/XMLSchema"  
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"  
    xmlns:fn="http://www.w3.org/2005/xpath-functions"  
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    exclude-result-prefixes="xs xd math"  
    version="2.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b>29 Juni 2020</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b>Kasper Lingbeek</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc>Loop alle FeatureTypeStyles </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:element name="html">
            <xsl:element name="head">
                <xsl:element name="link">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="type">text/css</xsl:attribute>
                    <xsl:attribute name="href">SLD.css</xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:element name="body">
                <xsl:apply-templates select="//*[local-name()='FeatureTypeStyle']" mode="div_tab"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xd:doc>
        <xd:desc>Maak div en loop alle Rules</xd:desc>
    </xd:doc>
    <xsl:template match="." mode="div_tab">
        <xsl:element name="div">
            <xsl:attribute name="class">tab_div</xsl:attribute>
            <xsl:variable name="h3" select="./fn:substring(./*[local-name() = 'Name']/text(), 1, 1)"/>
            <xsl:element name="h3">
                <xsl:value-of select="./*[local-name() = 'Description']/*[local-name()='Title']/text()"/>
            </xsl:element>
            <xsl:apply-templates select="." mode="Rules"/>
        </xsl:element>
    </xsl:template>
    <xd:doc>
        <xd:desc>Maak een div voor elke Rule</xd:desc>
    </xd:doc>
    <xsl:template match="." mode="Rules">
        <xsl:element name="div">
            <xsl:attribute name="class">fts_div</xsl:attribute>
            <xsl:element name="table">
                <xsl:attribute name="class">rule_table</xsl:attribute>
                <xsl:element name="tr">
                    <xsl:attribute name="class">rule_row</xsl:attribute>
                    <xsl:element name="td">
                        <xsl:attribute name="class">rule_cap_col</xsl:attribute>
                        <!-- label table -->
                        <xsl:element name="table">
                            <xsl:attribute name="class">label_table</xsl:attribute>
                            <xsl:element name="tr">
                                <xsl:attribute name="class">label_description</xsl:attribute>
                                <xsl:element name="td">SymbolName</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:attribute name="class">label_example</xsl:attribute>
                                <xsl:element name="td">Example</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Description</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">FeatureTypeName</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Filter</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">LayerName</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Fill - fill</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Fill - fill-opacity</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Fill - GraphicFill - Graphic - ExternalGraphic - OnlineResource - href</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Fill - GraphicFill - Graphic - ExternalGraphic - Format</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Stroke - stroke</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Stroke - stroke-opacity</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Stroke - stroke-width</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Stroke - stroke-linejoin</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Stroke - stroke-dasharray</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Stroke - stroke-linecap</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Graphic - Mark - Wellknownname</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Graphic - Mark - Fill - fill</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Graphic - Mark - Fill - fill-opacity</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Graphic - Mark - Stroke - stroke</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Graphic - Mark - Stroke - stroke-opacity</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Graphic - Mark - Stroke - stroke-width</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Graphic - Size</xsl:element>
                            </xsl:element>
                            <xsl:element name="tr">
                                <xsl:element name="td">Graphic - Rotation</xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:apply-templates select=".//*[local-name()='Rule']" mode="symbol"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xd:doc>
        <xd:desc>Vlakken</xd:desc>
    </xd:doc>
    <xsl:template match=".[fn:substring(*[local-name() = 'Name']/text(), 1, 1)='v']" mode="symbol">
        <xsl:element name="td">
            <xsl:attribute name="class">rule_cap_col</xsl:attribute>
            <xsl:element name="table">
                <xsl:attribute name="class">symbol_table</xsl:attribute>
                <xsl:element name="tr">
                    <!-- Symbolname -->
                    <xsl:element name="td">
                        <xsl:value-of select="./*[local-name()='Name']"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="tr">
                    <!-- Example -->
                    <xsl:attribute name="class">symbol_example</xsl:attribute>
                    <xsl:element name="td">
                        <xsl:element name="svg">
                            <xsl:attribute name="viewBox">-5 -5 106 58</xsl:attribute>
                            <xsl:attribute name="height">48</xsl:attribute>
                            <xsl:attribute name="width">96</xsl:attribute>
                            <xsl:if test="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'GraphicFill']">
                                <xsl:element name="image">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'GraphicFill']/*[local-name() = 'Graphic']/*[local-name() = 'ExternalGraphic']/*[local-name() = 'OnlineResource']/@xlink:href"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="x">0</xsl:attribute>
                                    <xsl:attribute name="y">0</xsl:attribute>
                                    <xsl:attribute name="preserveAspectRatio">xMidxMin slice</xsl:attribute>
                                </xsl:element>
                                <xsl:element name="image">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'GraphicFill']/*[local-name() = 'Graphic']/*[local-name() = 'ExternalGraphic']/*[local-name() = 'OnlineResource']/@xlink:href"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="x">48</xsl:attribute>
                                    <xsl:attribute name="y">0</xsl:attribute>
                                    <xsl:attribute name="preserveAspectRatio">xMidxMin slice</xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:element name="polygon">
                                <xsl:attribute name="points">0,0 0,48 96,48 96,0</xsl:attribute>
                                <xsl:attribute name="style">
                                    <!-- SvgParameter of graphicFill -->
                                    <xsl:variable name="style">
                                        <xsl:choose>
                                            <xsl:when test="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter']">
                                                <xsl:variable name="fill" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill']/text()"/>
                                                <xsl:variable name="fill-opacity" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill-opacity']/text()"/>
                                                <xsl:value-of select="concat('fill:', fn:replace(fn:replace(string(not($fill)),'true','#ffffff'),'false',string($fill)),';fill-opacity:', fn:replace(fn:replace(string(not($fill-opacity)),'true','1'),'false',string($fill-opacity)))" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'fill-opacity:0'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:variable name="stroke" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke']/text()"/>
                                        <xsl:variable name="stroke-opacity" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-opacity']/text()"/>
                                        <xsl:variable name="stroke-width" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-width']/text()"/>
                                        <xsl:variable name="stroke-linejoin" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-linejoin']/text()"/>
                                        <xsl:variable name="stroke-dasharray" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-dasharray']/text()"/>
                                        <xsl:variable name="stroke-linecap" select="./*[local-name() = 'PolygonSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-linecap']/text()"/>
                                        <xsl:value-of select="concat(';stroke:', $stroke, ';stroke-opacity:', $stroke-opacity, ';stroke-width:', $stroke-width, ';stroke-linejoin:', $stroke-linejoin, ';stroke-dasharray:', $stroke-dasharray, ';stroke-linecap:', $stroke-linecap)" />
                                    </xsl:variable>
                                    <xsl:value-of select="$style"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:apply-templates select="." mode="prop_list">
                    <xsl:with-param name="geom_type">PolygonSymbolizer</xsl:with-param>
                </xsl:apply-templates>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xd:doc>
        <xd:desc>Lijnen</xd:desc>
    </xd:doc>
    <xsl:template match=".[fn:substring(*[local-name() = 'Name']/text(), 1, 1)='l']" mode="symbol">
        <xsl:element name="td">
            <xsl:attribute name="class">rule_cap_col</xsl:attribute>
            <xsl:element name="table">
                <xsl:attribute name="class">symbol_table</xsl:attribute>
                <xsl:element name="tr">
                    <!-- Symbolname -->
                    <xsl:element name="td">
                        <xsl:value-of select="./*[local-name()='Name']"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="tr">
                    <!-- Example -->
                    <xsl:attribute name="class">symbol_example</xsl:attribute>
                    <xsl:element name="td">
                        <xsl:element name="svg">
                            <xsl:attribute name="height">48</xsl:attribute>
                            <xsl:attribute name="width">96</xsl:attribute>
                            <xsl:element name="line">
                                <!--<xsl:attribute name="points">15,15 15,50 100,50 100,15</xsl:attribute>-->
                                <xsl:attribute name="x1">0</xsl:attribute>
                                <xsl:attribute name="x2">96</xsl:attribute>
                                <xsl:attribute name="y1">24</xsl:attribute>
                                <xsl:attribute name="y2">24</xsl:attribute>
                                <xsl:attribute name="style">
                                    <xsl:variable name="stroke" select="./*[local-name() = 'LineSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke']/text()"/>
                                    <xsl:variable name="stroke-opacity" select="./*[local-name() = 'LineSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-opacity']/text()"/>
                                    <xsl:variable name="stroke-width" select="./*[local-name() = 'LineSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-width']/text()"/>
                                    <xsl:variable name="stroke-dasharray" select="./*[local-name() = 'LineSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-dasharray']/text()"/>
                                    <xsl:variable name="stroke-linecap" select="./*[local-name() = 'LineSymbolizer']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-linecap']/text()"/>
                                    <xsl:value-of select="concat('stroke:', $stroke, ';stroke-opacity:', $stroke-opacity, ';stroke-width:', $stroke-width, ';stroke-dasharray:', $stroke-dasharray, ';stroke-linecap:', $stroke-linecap)"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:element>
                        <xsl:apply-templates select="." mode="prop_list">
                            <xsl:with-param name="geom_type">LineSymbolizer</xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xd:doc>
        <xd:desc>Punten</xd:desc>
    </xd:doc>
    <xsl:template match=".[fn:substring(*[local-name() = 'Name']/text(), 1, 1)='p']" mode="symbol">
        <xsl:element name="td">
            <xsl:attribute name="class">rule_cap_col</xsl:attribute>
            <xsl:element name="table">
                <xsl:attribute name="class">symbol_table</xsl:attribute>
                <xsl:element name="tr">
                    <!-- Symbolname -->
                    <xsl:element name="td">
                        <xsl:value-of select="./*[local-name()='Name']"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="tr">
                    <!-- Example -->
                    <xsl:attribute name="class">symbol_example</xsl:attribute>
                    <xsl:element name="td">
                        <xsl:choose>
                            <!-- cross_fill -->
                            <xsl:when test="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='WellKnownName']/text()='cross_fill'">
                                <xsl:element name="svg">
                                    <xsl:variable name="size" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Size']/text()"/>
                                    <xsl:variable name="size_svg" select="math:sqrt(((fn:number($size) div 2) * (fn:number($size) div 2)) * 2) * 2"/>
                                    <xsl:attribute name="viewbox">0 0 24 24</xsl:attribute>
                                    <xsl:attribute name="height"><xsl:value-of select="$size_svg"/></xsl:attribute>
                                    <xsl:attribute name="width"><xsl:value-of select="$size_svg"/></xsl:attribute>
                                    <xsl:element name="polygon">
                                        <xsl:attribute name="x"><xsl:value-of select="(fn:number($size_svg) - fn:number($size)) div 2"/></xsl:attribute>
                                        <xsl:attribute name="y"><xsl:value-of select="(fn:number($size_svg) - fn:number($size)) div 2"/></xsl:attribute>
                                        <xsl:attribute name="points">10,0 14,0 14,10 24,10 24,14 14,14 14,24 10,24 10,14 0,14 0,10 10,10 10,0</xsl:attribute>
                                        <xsl:attribute name="style">
                                            <xsl:variable name="rotation" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Rotation']/text()"/>
                                            <!-- SvgParameter of graphicFill -->
                                            <xsl:variable name="style">
                                                <xsl:choose>
                                                    <xsl:when test="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter']">
                                                        <xsl:variable name="fill" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill']/text()"/>
                                                        <xsl:variable name="fill-opacity" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill-opacity']/text()"/>
                                                        <xsl:value-of select="concat('fill:', fn:replace(fn:replace(string(not($fill)),'true','#ffffff'),'false',string($fill)),';fill-opacity:', fn:replace(fn:replace(string(not($fill-opacity)),'true','1'),'false',string($fill-opacity)))" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="'fill-opacity:0'"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:variable name="stroke" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke']/text()"/>
                                                <xsl:variable name="stroke-opacity" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-opacity']/text()"/>
                                                <xsl:variable name="stroke-width" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-width']/text()"/>
                                                <xsl:variable name="stroke-linejoin" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-linejoin']/text()"/>
                                                <xsl:variable name="stroke-dasharray" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-dasharray']/text()"/>
                                                <xsl:variable name="stroke-linecap" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-linecap']/text()"/>
                                                <xsl:value-of select="concat(';stroke:', $stroke, ';stroke-opacity:', $stroke-opacity, ';stroke-width:', $stroke-width, ';stroke-linejoin:', $stroke-linejoin, ';stroke-dasharray:', $stroke-dasharray, ';stroke-linecap:', $stroke-linecap, ';transform-origin: center;transform: rotate(',$rotation,'deg);')" />
                                            </xsl:variable>
                                            <xsl:value-of select="$style"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <!-- Ster -->
                            <xsl:when test="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='WellKnownName']/text()='star'">
                                <xsl:element name="svg">
                                    <xsl:variable name="size" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Size']/text()"/>
                                    <xsl:variable name="size_svg" select="math:sqrt(((fn:number($size) div 2) * (fn:number($size) div 2)) * 2) * 2"/>
                                    <xsl:attribute name="viewbox">0 0 24 24</xsl:attribute>
                                    <xsl:attribute name="height"><xsl:value-of select="$size_svg"/></xsl:attribute>
                                    <xsl:attribute name="width"><xsl:value-of select="$size_svg"/></xsl:attribute>
                                    <xsl:element name="polygon">
                                        <xsl:attribute name="x"><xsl:value-of select="(fn:number($size_svg) - fn:number($size)) div 2"/></xsl:attribute>
                                        <xsl:attribute name="y"><xsl:value-of select="(fn:number($size_svg) - fn:number($size)) div 2"/></xsl:attribute>
                                        <xsl:attribute name="points">12,0 19,21 1,8 23,8 5,21 12,0</xsl:attribute>
                                        <xsl:attribute name="style">
                                            <xsl:variable name="rotation" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Rotation']/text()"/>
                                            <!-- SvgParameter of graphicFill -->
                                            <xsl:variable name="style">
                                                <xsl:choose>
                                                    <xsl:when test="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter']">
                                                        <xsl:variable name="fill" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill']/text()"/>
                                                        <xsl:variable name="fill-opacity" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill-opacity']/text()"/>
                                                        <xsl:value-of select="concat('fill:', fn:replace(fn:replace(string(not($fill)),'true','#ffffff'),'false',string($fill)),';fill-opacity:', fn:replace(fn:replace(string(not($fill-opacity)),'true','1'),'false',string($fill-opacity)))" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="'fill-opacity:0'"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:variable name="stroke" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke']/text()"/>
                                                <xsl:variable name="stroke-opacity" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-opacity']/text()"/>
                                                <xsl:variable name="stroke-width" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-width']/text()"/>
                                                <xsl:variable name="stroke-linejoin" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-linejoin']/text()"/>
                                                <xsl:variable name="stroke-dasharray" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-dasharray']/text()"/>
                                                <xsl:variable name="stroke-linecap" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-linecap']/text()"/>
                                                <xsl:value-of select="concat(';stroke:', $stroke, ';stroke-opacity:', $stroke-opacity, ';stroke-width:', $stroke-width, ';stroke-linejoin:', $stroke-linejoin, ';stroke-dasharray:', $stroke-dasharray, ';stroke-linecap:', $stroke-linecap, ';transform-origin: center;transform: rotate(',$rotation,'deg);')" />
                                            </xsl:variable>
                                            <xsl:value-of select="$style"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <!-- Driehoek -->
                            <xsl:when test="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='WellKnownName']/text()='triangle'">
                                <xsl:element name="svg">
                                    <xsl:variable name="size" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Size']/text()"/>
                                    <xsl:variable name="size_svg" select="math:sqrt(((fn:number($size) div 2) * (fn:number($size) div 2)) * 2) * 2"/>
                                    <xsl:attribute name="viewbox">0 0 24 24</xsl:attribute>
                                    <xsl:attribute name="height"><xsl:value-of select="$size_svg"/></xsl:attribute>
                                    <xsl:attribute name="width"><xsl:value-of select="$size_svg"/></xsl:attribute>
                                    <xsl:element name="polygon">
                                        <xsl:attribute name="x"><xsl:value-of select="(fn:number($size_svg) - fn:number($size)) div 2"/></xsl:attribute>
                                        <xsl:attribute name="y"><xsl:value-of select="(fn:number($size_svg) - fn:number($size)) div 2"/></xsl:attribute>
                                        <xsl:attribute name="points">12,0 24,24 0,24 12,0</xsl:attribute>
                                        <xsl:attribute name="style">
                                            <xsl:variable name="rotation" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Rotation']/text()"/>
                                            <!-- SvgParameter of graphicFill -->
                                            <xsl:variable name="style">
                                                <xsl:choose>
                                                    <xsl:when test="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter']">
                                                        <xsl:variable name="fill" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill']/text()"/>
                                                        <xsl:variable name="fill-opacity" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Fill']/*[local-name() = 'SvgParameter'][@name = 'fill-opacity']/text()"/>
                                                        <xsl:value-of select="concat('fill:', fn:replace(fn:replace(string(not($fill)),'true','#ffffff'),'false',string($fill)),';fill-opacity:', fn:replace(fn:replace(string(not($fill-opacity)),'true','1'),'false',string($fill-opacity)))" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="'fill-opacity:0'"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:variable name="stroke" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke']/text()"/>
                                                <xsl:variable name="stroke-opacity" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-opacity']/text()"/>
                                                <xsl:variable name="stroke-width" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-width']/text()"/>
                                                <xsl:variable name="stroke-linejoin" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-linejoin']/text()"/>
                                                <xsl:variable name="stroke-dasharray" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-dasharray']/text()"/>
                                                <xsl:variable name="stroke-linecap" select="./*[local-name() = 'PointSymbolizer']/*[local-name() = 'Graphic']/*[local-name() = 'Mark']/*[local-name() = 'Stroke']/*[local-name() = 'SvgParameter'][@name = 'stroke-linecap']/text()"/>
                                                <xsl:value-of select="concat(';stroke:', $stroke, ';stroke-opacity:', $stroke-opacity, ';stroke-width:', $stroke-width, ';stroke-linejoin:', $stroke-linejoin, ';stroke-dasharray:', $stroke-dasharray, ';stroke-linecap:', $stroke-linecap, ';transform-origin: center;transform: rotate(',$rotation,'deg);')" />
                                            </xsl:variable>
                                            <xsl:value-of select="$style"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <!-- square -->
                            <xsl:when test="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='WellKnownName']/text()='square'">
                                <xsl:element name="svg">
                                    <xsl:variable name="size" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Size']/text()"/>
                                    <xsl:variable name="size_svg" select="math:sqrt(((fn:number($size) div 2) * (fn:number($size) div 2)) * 2) * 2"/>
                                    <xsl:attribute name="height"><xsl:value-of select="$size_svg"/></xsl:attribute>
                                    <xsl:attribute name="width"><xsl:value-of select="$size_svg"/></xsl:attribute>
                                    <xsl:element name="rect">
                                        <xsl:variable name="rotation" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Rotation']/text()"/>
                                        <xsl:variable name="fill" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Fill']/*[local-name()='SvgParameter'][@name='fill']/text()"/>
                                        <xsl:variable name="fill-opacity" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Fill']/*[local-name()='SvgParameter'][@name='fill-opacity']/text()"/>
                                        <xsl:variable name="stroke" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Stroke']/*[local-name()='SvgParameter'][@name='stroke']/text()"/>
                                        <xsl:variable name="stroke-opacity" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Stroke']/*[local-name()='SvgParameter'][@name='stroke-opacity']/text()"/>
                                        <xsl:variable name="stroke-width" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Stroke']/*[local-name()='SvgParameter'][@name='stroke-width']/text()"/>
                                        <xsl:attribute name="x"><xsl:value-of select="(fn:number($size_svg) - fn:number($size)) div 2"/></xsl:attribute>
                                        <xsl:attribute name="y"><xsl:value-of select="(fn:number($size_svg) - fn:number($size)) div 2"/></xsl:attribute>
                                        <xsl:attribute name="width"><xsl:value-of select="$size"/></xsl:attribute>
                                        <xsl:attribute name="height"><xsl:value-of select="$size"/></xsl:attribute>
                                        <xsl:attribute name="style">
                                            <xsl:value-of select="concat('fill:', $fill, ';fill-opacity:', $fill-opacity,';stroke:', $stroke, ';stroke-opacity:', $stroke-opacity, ';stroke-width:', $stroke-width, ';transform-origin: center;transform: rotate(',$rotation,'deg);')"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <!-- circle -->
                            <xsl:when test="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='WellKnownName']/text()='circle'">
                                <xsl:element name="svg">
                                    <xsl:variable name="size" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Size']/text()"/>
                                    <xsl:attribute name="height"><xsl:value-of select="$size"/></xsl:attribute>
                                    <xsl:attribute name="width"><xsl:value-of select="$size"/></xsl:attribute>
                                    <xsl:element name="circle">
                                        <xsl:variable name="rotation" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Rotation']/text()"/>
                                        <xsl:variable name="fill" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Fill']/*[local-name()='SvgParameter'][@name='fill']/text()"/>
                                        <xsl:variable name="fill-opacity" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Fill']/*[local-name()='SvgParameter'][@name='fill-opacity']/text()"/>
                                        <xsl:variable name="stroke" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Stroke']/*[local-name()='SvgParameter'][@name='stroke']/text()"/>
                                        <xsl:variable name="stroke-opacity" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Stroke']/*[local-name()='SvgParameter'][@name='stroke-opacity']/text()"/>
                                        <xsl:variable name="stroke-width" select="./*[local-name()='PointSymbolizer']/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Stroke']/*[local-name()='SvgParameter'][@name='stroke-width']/text()"/>
                                        <xsl:attribute name="cx"><xsl:value-of select="fn:number($size) div 2"/></xsl:attribute>
                                        <xsl:attribute name="cy"><xsl:value-of select="fn:number($size) div 2"/></xsl:attribute>
                                        <xsl:attribute name="r"><xsl:value-of select="fn:number($size) div 2"/></xsl:attribute>
                                        <xsl:attribute name="style">
                                            <xsl:value-of select="concat('fill:', $fill, ';fill-opacity:', $fill-opacity,';stroke:', $stroke, ';stroke-opacity:', $stroke-opacity, ';stroke-width:', $stroke-width)"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:apply-templates select="." mode="prop_list">
                            <xsl:with-param name="geom_type">PointSymbolizer</xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xd:doc>
        <xd:desc>Property list</xd:desc>
        <xd:param name="geom_type"/>
    </xd:doc>
    <xsl:template match="." mode="prop_list">
        <xsl:param name="geom_type"/>
        <xsl:element name="tr">
            <!-- Description -->
            <xsl:attribute name="class">symbol_description</xsl:attribute>
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()='Description']/*[local-name()='Title']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- FeatureTypeName -->
            <xsl:element name="td">
                <xsl:value-of select="./../*[local-name()='Name']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Filter -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()='Filter']/*[local-name()='PropertyIsEqualTo']/*[local-name()='PropertyName']"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- LayerName -->
            <xsl:element name="td">
                <xsl:value-of select="./../../../*[local-name()='Name']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Fill - fill -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Fill']/*[local-name()='SvgParameter' and @name='fill']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Fill - fill-opacity -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Fill']/*[local-name()='SvgParameter' and @name='fill-opacity']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Fill - GraphicFill - Graphic - ExternalGraphic - OnlineResource - href -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Fill']/*[local-name()='GraphicFill']/*[local-name()='Graphic']/*[local-name()='ExternalGraphic']/*[local-name()='OnlineResource']/@xlink:href"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Fill - GraphicFill - Graphic - ExternalGraphic - Format -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Fill']/*[local-name()='GraphicFill']/*[local-name()='Graphic']/*[local-name()='ExternalGraphic']/*[local-name()='Format']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Stroke - stroke -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Stroke']/*[local-name()='SvgParameter' and @name='stroke']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Stroke - stroke-opacity -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Stroke']/*[local-name()='SvgParameter' and @name='stroke-opacity']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Stroke - stroke-width -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Stroke']/*[local-name()='SvgParameter' and @name='stroke-width']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Stroke - stroke-linejoin -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Stroke']/*[local-name()='SvgParameter' and @name='stroke-linejoin']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Stroke - stroke-dasharray -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Stroke']/*[local-name()='SvgParameter' and @name='stroke-dasharray']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Stroke - stroke-linecap -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Stroke']/*[local-name()='SvgParameter' and @name='stroke-linecap']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Graphic - Mark - Wellknownname -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='WellKnownName']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Graphic - Mark - Fill - fill -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Fill']/*[local-name()='SvgParameter' and @name='fill']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Graphic - Mark - Fill - fill-opacity -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Fill']/*[local-name()='SvgParameter' and @name='fill-opacity']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Graphic - Mark - Stroke - stroke -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Stroke']/*[local-name()='SvgParameter' and @name='stroke']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Graphic - Mark - Stroke - stroke-opacity -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Stroke']/*[local-name()='SvgParameter' and @name='stroke-opacity']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Graphic - Mark - Stroke - stroke-width -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Graphic']/*[local-name()='Mark']/*[local-name()='Stroke']/*[local-name()='SvgParameter' and @name='stroke-width']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Graphic - Size -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Graphic']/*[local-name()='Size']/text()"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="tr">
            <!-- Graphic - Rotation -->
            <xsl:element name="td">
                <xsl:value-of select="./*[local-name()=$geom_type]/*[local-name()='Graphic']/*[local-name()='Rotation']/text()"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>