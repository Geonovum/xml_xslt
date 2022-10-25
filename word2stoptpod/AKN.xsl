<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns="https://standaarden.overheid.nl/stop/imop/tekst/" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <xsl:param name="element" select="('Aanhef','Afdeling','AlgemeneToelichting','Artikel','ArtikelgewijzeToelichting','Begrip','Begrippenlijst','Bijlage','Boek','Citaat','Deel','Divisie','Divisietekst','ExtIoRef','Figuur','Formule','Hoofdstuk','Inhoudsopgave','InleidendeTekst','IntIoRef','Kadertekst','Li','Lichaam','Lid','Lijst','Motivering','Paragraaf','Rectificatietekst','RegelingOpschrift','Sluiting','Subparagraaf','Subsubparagraaf','table','Titel','Toelichting','WijzigArtikel','WijzigBijlage')"/>
    <xsl:param name="element_ref" select="('formula_1','subchp','genrecital','art','artrecital','item','list','cmp','book','cit','part','div','content','ref','img','math','chp','toc','intro','ref','recital','item','body','para','list','acc','subsec','content','longTitle','formula_2','subsec','subsec','table','title','recital','art','cmp')"/>
    <xsl:param name="element_wId_eId" select="('waar','onwaar','waar','onwaar','waar','onwaar','onwaar','onwaar','onwaar','onwaar','onwaar','onwaar','onwaar','onwaar','onwaar','onwaar','onwaar','waar','onwaar','onwaar','onwaar','onwaar','waar','onwaar','onwaar','waar','onwaar','onwaar','waar','waar','onwaar','onwaar','onwaar','onwaar','waar','onwaar','onwaar')"/>

    <!-- Variabelen eId en unique_eId bevatten een mapping van alle elementen in het voorbeeldbestand naar hun eId. -->

    <xsl:variable name="eId">
        <xsl:apply-templates mode="eId"/>
    </xsl:variable>

    <xsl:template match="element()" mode="eId">
        <xsl:variable name="index" select="fn:index-of($element,local-name())"/>
        <xsl:variable name="count" select="if ($element_wId_eId[$index] eq 'onwaar') then fn:string-join(('o',string(count(.|preceding-sibling::*[local-name() eq $element[$index]]))),'_') else null"/>
        <xsl:choose>
            <xsl:when test="$index gt 0">
                <xsl:element name="node">
                    <xsl:attribute name="id" select="generate-id()"/>
                    <xsl:attribute name="name" select="local-name()"/>
                    <xsl:attribute name="wId_eId" select="$element_wId_eId[$index]"/>
                    <!-- Een opsomming is genummerd als binnen Lijst onderliggende LiNummer onderling verschilt -->
                    <xsl:attribute name="eId">
                        <xsl:call-template name="check_string">
                            <xsl:with-param name="string" select="fn:string-join(($element_ref[$index],(Kop/Nummer,LiNummer[count(fn:distinct-values(ancestor::Lijst[1]/Li/LiNummer)) ne 1],LidNummer,$count)[1]),'_')"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:apply-templates select="processing-instruction('marker')" mode="eId"/>
                    <xsl:apply-templates select="element()" mode="eId"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="element()" mode="eId"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="processing-instruction('marker')" mode="eId">
        <xsl:attribute name="marker" select="string(.)"/>
    </xsl:template>

    <xsl:template name="check_string">
        <xsl:param name="string"/>
        <xsl:variable name="codepoints" select="fn:string-to-codepoints($string)"/>
        <xsl:variable name="check_string">
            <xsl:for-each select="$codepoints">
                <xsl:choose>
                    <xsl:when test="(. ge 48) and (. le 57)">
                        <!-- cijfers -->
                        <node><xsl:value-of select="."/></node>
                    </xsl:when>
                    <xsl:when test="((. ge 65) and (. le 90)) or ((. ge 97) and (. le 122))">
                        <!-- letters -->
                        <node><xsl:value-of select="."/></node>
                    </xsl:when>
                    <xsl:when test="(. eq 45)">
                        <!-- dash -->
                        <node><xsl:value-of select="."/></node>
                    </xsl:when>
                    <xsl:when test="(. eq 46)">
                        <!-- punt -->
                        <node><xsl:value-of select="."/></node>
                    </xsl:when>
                    <xsl:when test="(. eq 95)">
                        <!-- onderkast -->
                        <node><xsl:value-of select="."/></node>
                    </xsl:when>
                    <xsl:when test="(. eq 32)">
                        <!-- spatie -->
                    </xsl:when>
                    <xsl:otherwise>
                        <node><xsl:value-of select="46"/></node>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="fn:codepoints-to-string($check_string/node[(. ne '46') or following::node[. ne '46']])"/>
    </xsl:template>

    <xsl:variable name="unique_eId">
        <xsl:for-each select="$eId/node">
            <xsl:call-template name="check_eId">
                <xsl:with-param name="id" select="./@id"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="check_eId">
        <xsl:param name="id"/>
        <xsl:variable name="node" select="$eId//node[@id eq $id]"/>
        <!-- Controleer of element inst_volgnummer krijgt -->
        <xsl:variable name="test_inst" select="count($eId//node[@id eq $node/@id]/(parent::node,root())[1]/node[@eId eq $node/@eId]) gt 1"/>
        <!-- Controleer of element inst_1 krijgt -->
        <xsl:variable name="test_inst1" select="$eId//node[@id eq $node/@id]/preceding-sibling::node[@eId eq $node/@eId]"/>
        <xsl:variable name="count" select="if (($test_inst) and ($test_inst1)) then concat('inst',count($eId//node[@id eq $node/@id]/(.|preceding-sibling::node[@eId eq $node/@eId]))) else null"/>
        <xsl:element name="node">
            <xsl:copy-of select="$node/@*"/>
            <xsl:attribute name="eId" select="fn:string-join(($node/@eId,$count),'_')"/>
            <xsl:for-each select="$node/node">
                <xsl:call-template name="check_eId">
                    <xsl:with-param name="id" select="@id"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!-- elementen verwerken -->

    <xsl:template match="element()">
        <xsl:variable name="id" select="generate-id()"/>
        <xsl:variable name="wId_bg" select="tokenize((preceding::processing-instruction('akn'))[last()],'_')[1]"/>
        <xsl:variable name="wId_versie" select="tokenize((preceding::processing-instruction('akn'))[last()],'_')[2]"/>
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:if test="$unique_eId//node[@id eq $id]">
                <xsl:variable name="eId" select="fn:string-join($unique_eId//node[@id eq $id]/(.|ancestor::node[not(descendant-or-self::node[@eId eq 'body'])])/@eId,'__')"/>
                <xsl:attribute name="eId" select="$eId"/>
                <xsl:attribute name="wId">
                    <xsl:choose>
                        <xsl:when test="$unique_eId//node[@id eq $id]/@wId_eId eq 'waar'">
                            <xsl:value-of select="$eId"/>
                        </xsl:when>
                        <xsl:when test="$unique_eId//node[@id eq $id]/@wId_eId eq 'onwaar'">
                            <xsl:value-of select="fn:string-join((fn:string-join(($wId_bg,$wId_versie),'_'),$eId),'__')"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="namespace::*"/>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

    <!-- attributen verwerken -->

    <xsl:template match="@eId|@wId">
        <!-- doe niets -->
    </xsl:template>

    <xsl:template match="@ref">
        <xsl:variable name="marker" select="."/>
        <xsl:variable name="ref" select="$unique_eId//node[@marker eq $marker]/@eId"/>
        <xsl:choose>
            <xsl:when test="$ref">
                <xsl:attribute name="ref" select="$ref"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@scope">
        <xsl:variable name="marker" select="."/>
        <xsl:variable name="scope" select="$unique_eId//node[@marker eq $marker]/@name"/>
        <xsl:choose>
            <xsl:when test="$scope">
                <xsl:attribute name="scope" select="$scope"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="namespace::*">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- tekst opschonen -->

    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test="(normalize-space(.)='') and contains(.,'&#10;')">
                <!-- lege tekst met een zachte return is indentation -->
                <xsl:value-of select="fn:tokenize(.,'&#10;')[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="myArray">
                    <xsl:value-of select="fn:tokenize(.,'\s+')"/>
                </xsl:variable>
                <xsl:value-of select="fn:concat($myArray,'')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="comment()">
        <xsl:copy-of select="."/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>

    <xsl:template match="processing-instruction()">
        <!-- doe niets -->
    </xsl:template>

</xsl:stylesheet>