<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns="https://standaarden.overheid.nl/stop/imop/tekst/"
    xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
    
    <!--
        VUL ONDERSTAANDE VARIABELEN IN EN DRAAI NA RUNNEN DIT SCRIPT OOK HET AKN-UPDATE-SCRIPT
        ======================================================================================
        -->

    <!--  ID bevoegd gezag  -->
    <xsl:variable name="idbv" select="string('gm0534')"/>
    <!-- Soort bevoegd gezag -->
    <xsl:variable name="srtbv" select="string('gemeente')"/>
    <!-- Onderwerp -->
    <xsl:variable name="onderwerp" select="string('c_6b728132')"/>
    <!-- media -->
    <!-- Overheidsdomein -->
    <xsl:variable name="overheidsdomein" select="string('c_3708ac5e')"/>
    <!-- bouwen, wonen en leefomgeving -->
    <!-- rechtsgebied -->
    <xsl:variable name="rechtsgebied" select="string('c_8ad05f6d')"/>
    <!-- ruimtelijke ordening en milieu -->
    <!-- soortInformatieobject -->
    <xsl:variable name="soortInformatieobjecten"
        select="
            'GIO_archeologische_verwachtingswaarde',
            'GIO_bouwvlak',
            'GIO_buisleiding',
            'GIO_duurzame_bloementuin',
            'GIO_erfgoed',
            'GIO_geluidscontour',
            'GIO_groepsrisico',
            'GIO_heerlijke_woonplaats',
            'GIO_herstructurering',
            'GIO_hollandse_weides',
            'GIO_levendige_linten',
            'GIO_niet_openbaar',
            'GIO_openbaar',
            'GIO_park_Vogelenzang',
            'GIO_plaatsgebonden_risico',
            'GIO_uitzondering_legaal_bestaand_gebruik',
            'GIO_waardering_hoog',
            'GIO_waardering_laag',
            'GIO_waardering_middel',
            'GIO_waardering_middelhoog',
            'GIO_waardevolle_boom',
            'GIO_waterstaat'
            "/>
    <xsl:variable name="soortProcedure" select="string('/join/id/stop/proceduretype_definitief')"/>
    <xsl:variable name="soortProcedureStap" select="string('/join/id/stop/procedurestap/stap_002')"/>
    <xsl:variable name="soortProcedureStapVoltooidOp" select="string('2019-11-01')"/>
    <xsl:variable name="nieuweregelingWordtId" select="string('WvL-20190906-1643')"/>
    <xsl:variable name="nieuweregelingComponent" select="string('main')"/>
    <xsl:variable name="eIdBeoogdeRegeling"
        select="string('chp_1__subchp_1.2__subsec_1.2.1__art_1.3')"/>
    <xsl:variable name="lastPartFBRWork"/>


    <xsl:template match="/">
        <AanleveringBesluit  schemaversie="0.98.kern"
            xmlns="https://standaarden.overheid.nl/stop/imop/instrument/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:cons="https://standaarden.overheid.nl/stop/imop/consolidatie/"
            xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
            xmlns:meta="https://standaarden.overheid.nl/stop/imop/metadata/"
            xmlns:id="https://standaarden.overheid.nl/stop/imop/identificatie/"
            xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
            xmlns:tooi="https://standaarden.overheid.nl/stop/imop/tooi/"
            xsi:schemaLocation="http://www.overheid.nl/imop/def# omgevingsplan_hillegom_0.98.3-kern/xsd_0-98-3-kern/xsd/stop/imop-instrument.xsd">
        <BesluitVersie>
            <xsl:variable name="fbrwork"
                select="//tekst:Metadata/tekst:Uitspraak[@eigenschap = 'imop:identificatie']/tekst:Object[@type = 'imop:AKNIdentification']/tekst:Eigenschap[@naam = 'imop:FRBRWork']/tekst:Object[@type = 'imop:FRBRWorkIdentification']/tekst:Eigenschap[@naam = 'imop:FRBRuri']/tekst:Waarde/text()"/>
            <xsl:variable name="fbrexpression"
                select="//tekst:Metadata/tekst:Uitspraak[@eigenschap = 'imop:identificatie']/tekst:Object[@type = 'imop:AKNIdentification']/tekst:Eigenschap[@naam = 'imop:FRBRExpression']/tekst:Object[@type = 'imop:FRBRExpressionIdentification']/tekst:Eigenschap[@naam = 'imop:FRBRuri']/tekst:Waarde/text()"/>
            <xsl:variable name="lastPartFBRWork"
                select="substring($fbrwork, string-length(concat('/akn/nl/bill/', $idbv, '/')) + 1)"/>
            <xsl:variable name="yearPartFBRWork" select="substring-before($lastPartFBRWork, '/')"/>
            <xsl:variable name="idPartFBRWork" select="substring-after($lastPartFBRWork, '/')"/>
            <xsl:variable name="datePartFBFRExpression"
                select="substring($fbrexpression, string-length(concat('/akn/nl/bill/', $idbv, '/', $yearPartFBRWork, '/', $idPartFBRWork, '/')) + 1)"/>
            <xsl:element name="ExpressionIdentificatie"
                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                <xsl:element name="FRBRWork"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:value-of select="$fbrwork"/>
                </xsl:element>
                <xsl:element name="FRBRExpression"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:value-of select="$fbrexpression"/>
                </xsl:element>
                <xsl:element name="soortWork"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/"
                    >/join/id/stop/work_003</xsl:element>
            </xsl:element>
            <xsl:element name="BesluitMetadata"
                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                <xsl:element name="maker"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:value-of select="concat('/join/id/stop/', $srtbv, '/', $idbv)"/>
                </xsl:element>
                <xsl:element name="eindverantwoordelijke"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:value-of select="concat('/join/id/stop/', $srtbv, '/', $idbv)"/>
                </xsl:element>
                <xsl:element name="officieleTitel"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:value-of select="//tekst:Metadata/tekst:Uitspraak[@eigenschap='imop:citeertitel']/tekst:Waarde/text()"/>
                </xsl:element>
                <xsl:element name="onderwerpen"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:element name="onderwerp"
                        namespace="https://standaarden.overheid.nl/stop/imop/data/">
                        <xsl:value-of select="concat('/tooi/def/concept/', $onderwerp)"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="overheidsdomein"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:value-of select="concat('/tooi/def/concept/', $overheidsdomein)"/>
                </xsl:element>
                <xsl:element name="rechtsgebieden"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:element name="rechtsgebied"
                        namespace="https://standaarden.overheid.nl/stop/imop/data/">
                        <xsl:value-of select="concat('/tooi/def/concept/', $rechtsgebied)"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="informatieobjectRefs"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:for-each select="$soortInformatieobjecten">
                        <xsl:element name="informatieobjectRef"
                            namespace="https://standaarden.overheid.nl/stop/imop/data/">
                            <xsl:value-of
                                select="concat('/join/id/regdata/', $idbv, '/', $yearPartFBRWork, '/', ., '/', $datePartFBFRExpression, ';', $idPartFBRWork)"
                            />
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
            <xsl:element name="Procedure"
                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                <xsl:element name="Procedureverloop"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:element name="bekendOp"
                        namespace="https://standaarden.overheid.nl/stop/imop/data/">
                        <xsl:value-of
                            select="//tekst:Metadata/tekst:Uitspraak[@eigenschap = 'imop:datumBekendmaking']/tekst:Waarde/text()"
                        />
                    </xsl:element>
                    <xsl:element name="soortProcedure"
                        namespace="https://standaarden.overheid.nl/stop/imop/data/">
                        <xsl:value-of select="$soortProcedure"/>
                    </xsl:element>
                    <xsl:element name="procedurestappen"
                        namespace="https://standaarden.overheid.nl/stop/imop/data/">
                        <xsl:element name="Procedurestap"
                            namespace="https://standaarden.overheid.nl/stop/imop/data/">
                            <xsl:element name="soortStap"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of select="$soortProcedureStap"/>
                            </xsl:element>
                            <xsl:element name="voltooidOp"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of select="$soortProcedureStapVoltooidOp"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="Besluit" namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
                <xsl:if test="//tekst:NieuweRegeling">
                    <xsl:element name="NieuweRegeling"
                        namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
                        <xsl:attribute name="FRBRwork"
                            select="concat('/akn/nl/act/', $idbv, '/', $lastPartFBRWork)"/>
                        <xsl:attribute name="wordt"
                            select="concat('/akn/nl/act/', $idbv, '/', $nieuweregelingWordtId)"/>
                        <xsl:attribute name="componentnaam" select="$nieuweregelingComponent"/>
                        <xsl:apply-templates select="//tekst:NieuweRegeling/tekst:RegelingOpschrift"/>
                        <xsl:apply-templates select="//tekst:NieuweRegeling/tekst:Lichaam"/>
                        <xsl:apply-templates select="//tekst:NieuweRegeling/tekst:Bijlage"/>
                        <xsl:apply-templates select="//tekst:NieuweRegeling/tekst:Toestand"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="//tekst:Regeling">
                    <xsl:apply-templates select="//tekst:Regeling"/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="BesluitDoel"
                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                <xsl:element name="BeoogdeRegelgeving"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:element name="BeoogdeRegeling"
                        namespace="https://standaarden.overheid.nl/stop/imop/data/">
                        <xsl:element name="doel"
                            namespace="https://standaarden.overheid.nl/stop/imop/data/">
                            <xsl:value-of
                                select="concat('/join/id/proces/', $idbv, '/', $yearPartFBRWork, '/', $nieuweregelingWordtId)"
                            />
                        </xsl:element>
                        <xsl:if test="//tekst:NieuweRegeling">
                            <xsl:element name="instrumentVersie"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of
                                    select="//tekst:NieuweRegeling/tekst:Metadata/tekst:Uitspraak[@eigenschap = 'imop:wordtVersie']/tekst:Waarde/text()"
                                />
                            </xsl:element>
                            <xsl:element name="eId"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of select="string(//tekst:NieuweRegeling/tekst:RegelingOpschrift/@eId)"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="//tekst:Regeling">
                            <xsl:element name="instrumentVersie"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of
                                    select="//tekst:Regeling/tekst:WijzigBijlage/tekst:Metadata/tekst:Uitspraak[@eigenschap = 'imop:wordtVersie']/tekst:Waarde/text()"
                                />
                            </xsl:element>
                            <xsl:element name="eId"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of select="string(//tekst:Regeling/tekst:RegelingOpschrift/@eId)"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Tijdstempels"
                    namespace="https://standaarden.overheid.nl/stop/imop/data/">
                    <xsl:element name="Tijdstempel"
                        namespace="https://standaarden.overheid.nl/stop/imop/data/">
                        <xsl:element name="doel"
                            namespace="https://standaarden.overheid.nl/stop/imop/data/">
                            <xsl:value-of
                                select="concat('/join/id/proces/', $idbv, '/', $yearPartFBRWork, '/', $nieuweregelingWordtId)"
                            />
                        </xsl:element>
                        <xsl:if test="//tekst:NieuweRegeling">
                            <xsl:element name="soortTijdstempel"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of select="string('inwerkingtreding')"/>
                            </xsl:element>
                            <xsl:element name="datum"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of
                                    select="//tekst:NieuweRegeling/tekst:Metadata/tekst:Uitspraak[@eigenschap = 'imop:datumInwerkingtreding']/tekst:Waarde/text()"
                                />
                            </xsl:element>
                            <xsl:element name="eId"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of select="string(//tekst:NieuweRegeling/tekst:RegelingOpschrift/@eId)"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="//tekst:Regeling">
                            <xsl:element name="soortTijdstempel"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of select="string('inwerkingtreding')"/>
                            </xsl:element>
                            <xsl:element name="datum"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of
                                    select="//tekst:Regeling/tekst:Lichaam/tekst:WijzigArtikel/tekst:Metadata/tekst:Uitspraak[@eigenschap = 'imop:datumInwerkingtreding']/tekst:Waarde/text()"
                                />
                            </xsl:element>
                            <xsl:element name="eId"
                                namespace="https://standaarden.overheid.nl/stop/imop/data/">
                                <xsl:value-of select="string(//tekst:Regeling/tekst:RegelingOpschrift/@eId)"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </BesluitVersie>
        </AanleveringBesluit>
    </xsl:template>

    <xsl:template match="//tekst:Regeling"
        xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@type" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@id" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@soort" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@eId" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@wId" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tekst:MaakInitieleRegeling" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="FRBRwork"
                select="concat('/akn/nl/act/', $idbv, '/', $lastPartFBRWork)"/>
            <xsl:attribute name="wordt"
                select="concat('/akn/nl/act/', $idbv, '/', $nieuweregelingWordtId)"/>
            <xsl:attribute name="componentnaam" select="$nieuweregelingComponent"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="tekst:Metadata"
        xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"/>

    <xsl:template match="@* | node()" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
        <xsl:choose>
            <xsl:when test="string(node-name(.)) = 'Lijst'">
                <xsl:copy>
                    <xsl:apply-templates select="@* except (@id | @soort) | node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="string(node-name(.)) = 'Noot'">
                <xsl:copy>
                    <xsl:apply-templates select="@* except @soort | node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="string(node-name(.)) = 'Ondertekening'">
                <xsl:copy>
                    <xsl:apply-templates select="@* except (@eId | @wId) | node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* except (@type | @id | @soort) | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
