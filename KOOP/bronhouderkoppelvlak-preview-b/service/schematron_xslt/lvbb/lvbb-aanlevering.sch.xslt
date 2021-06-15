<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
                xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
                xmlns:lvbba="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->
   <!--PROLOG-->
   <!--XSD TYPES FOR XSLT2-->
   <!--KEYS AND FUNCTIONS-->
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M6"/>
      <xsl:apply-templates select="/" mode="M7"/>
      <xsl:apply-templates select="/" mode="M8"/>
      <xsl:apply-templates select="/" mode="M9"/>
      <xsl:apply-templates select="/" mode="M10"/>
      <xsl:apply-templates select="/" mode="M11"/>
      <xsl:apply-templates select="/" mode="M12"/>
      <xsl:apply-templates select="/" mode="M13"/>
      <xsl:apply-templates select="/" mode="M14"/>
      <xsl:apply-templates select="/" mode="M15"/>
      <xsl:apply-templates select="/" mode="M16"/>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN sch_lvbba_003BeoogdInformatieobject in overeenstemming met ExtIoRef/@eId-->
   <!--RULE -->
   <xsl:template match="data:BeoogdInformatieobject/data:eId"
                 priority="1001"
                 mode="M6">
      <xsl:variable name="data-eId" select="normalize-space(.)"/>
      <xsl:variable name="joinID"
                    select="normalize-space(parent::data:*/data:instrumentVersie)"/>
      <xsl:variable name="refs">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="//tekst:ExtIoRef[not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor::tekst:Verwijder)]">
            <set>
               <id>
                  <xsl:if test="ancestor::tekst:*[@componentnaam][1]">
                     <xsl:value-of select="concat('!', ancestor::tekst:*[@componentnaam][1]/@componentnaam, '#')"/>
                  </xsl:if>
                  <xsl:value-of select="@eId"/>
               </id>
               <join>
                  <xsl:value-of select="@ref"/>
               </join>
            </set>
         </xsl:for-each>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$refs/set/id[. = $data-eId]"/>
         <xsl:otherwise>{"code": "BHKV1003", "ref": "<xsl:text/>
            <xsl:value-of select="$data-eId"/>
            <xsl:text/>", "melding": "De eId <xsl:text/>
            <xsl:value-of select="$data-eId"/>
            <xsl:text/> van BeoogdInformatieobject komt niet voor als eId van een ExtIoRef, Controleer de referenties naar de ExtIoRef's", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$refs/set/id[. = $data-eId] and $refs/set[id[. = $data-eId]]/join = $joinID"/>
         <xsl:otherwise> {"code": "BHKV1036", "eId": "<xsl:text/>
            <xsl:value-of select="$data-eId"/>
            <xsl:text/>", "instrument": "<xsl:text/>
            <xsl:value-of select="$joinID"/>
            <xsl:text/>", "melding": "De identifier van instrumentVersie \"<xsl:text/>
            <xsl:value-of select="$joinID"/>
            <xsl:text/>\" komt niet overeen met de ExtIoRef met eId \"<xsl:text/>
            <xsl:value-of select="$data-eId"/>
            <xsl:text/>\". Corrigeer de identifier of de eId zodat deze gelijk zijn.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="lvbba:AanleveringBesluit//data:BeoogdInformatieobject[not(data:eId)][data:instrumentVersie]"
                 priority="1000"
                 mode="M6">
      <xsl:variable name="ID" select="normalize-space(data:instrumentVersie)"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="ancestor::lvbba:AanleveringBesluit//tekst:ExtIoRef[not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor::tekst:Verwijder)][@ref = $ID]"/>
         <xsl:otherwise> {"code": "BHKV1037", "id": "<xsl:text/>
            <xsl:value-of select="$ID"/>
            <xsl:text/>", "melding": "De identifier van instrumentVersie \"<xsl:text/>
            <xsl:value-of select="$ID"/>
            <xsl:text/>\" komt niet voor als de join identifier van een ExtIoRef. Controleer de instrumentVersie of voeg een ExtIoRef toe aan de tekst van het besluit.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_004Tijdstempels in ontwerpbesluit-->
   <!--RULE -->
   <xsl:template match="data:BesluitMetadata/data:soortProcedure[normalize-space(./string()) = '/join/id/stop/proceduretype_ontwerp']"
                 priority="1000"
                 mode="M7">

		<!--REPORT fout-->
      <xsl:if test="ancestor::lvbba:AanleveringBesluit//data:ConsolidatieInformatie/data:Tijdstempels"> {"code": "BHKV1004", "melding": "Het ontwerpbesluit heeft tijdstempels, dit is niet toegestaan. Verwijder de tijdstempels.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_005Besluit met soort werk '/join/id/stop/work_003'-->
   <!--RULE -->
   <xsl:template match="lvbba:AanleveringBesluit/lvbba:BesluitVersie"
                 priority="1000"
                 mode="M8">
      <xsl:variable name="soortWork"
                    select="normalize-space(data:ExpressionIdentificatie/data:soortWork/./string())"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$soortWork = '/join/id/stop/work_003'"/>
         <xsl:otherwise>{"code": "BHKV1005", "id": "<xsl:text/>
            <xsl:value-of select="$soortWork"/>
            <xsl:text/>", "melding": "Het geleverde besluit heeft als soortWork '<xsl:text/>
            <xsl:value-of select="$soortWork"/>
            <xsl:text/>' , Dit moet zijn: '/join/id/stop/work_003'.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_006Regeling met soort werk '/join/id/stop/work_019-->
   <!--RULE -->
   <xsl:template match="tekst:RegelingCompact | tekst:RegelingKlassiek | tekst:RegelingVrijetekst"
                 priority="1000"
                 mode="M9">
      <xsl:variable name="soortWork" select="'/join/id/stop/work_019'"/>
      <xsl:variable name="controle">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie">
            <xsl:choose>
               <xsl:when test="normalize-space(data:ExpressionIdentificatie/data:soortWork/./string()) = $soortWork"/>
               <xsl:otherwise>
                  <xsl:value-of select="concat(normalize-space(data:ExpressionIdentificatie/data:soortWork/./string()), ' ')"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$controle = ''"/>
         <xsl:otherwise>{"code": "BHKV1006", "id": "<xsl:text/>
            <xsl:value-of select="normalize-space(replace($controle, ' /', ', /'))"/>
            <xsl:text/>", "melding": "Het geleverde regelingversie heeft als soortWork '<xsl:text/>
            <xsl:value-of select="normalize-space(replace($controle, ' /', ', /'))"/>
            <xsl:text/>'. Dit moet voor een RegelingCompact, RegelingKlassiek of RegelingVrijetekst zijn '/join/id/stop/work_019'", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_021Regeling met soort werk '/join/id/stop/work_021-->
   <!--RULE -->
   <xsl:template match="tekst:RegelingTijdelijkdeel" priority="1000" mode="M10">
      <xsl:variable name="soortWork" select="'/join/id/stop/work_021'"/>
      <xsl:variable name="controle">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie">
            <xsl:choose>
               <xsl:when test="normalize-space(data:ExpressionIdentificatie/data:soortWork/./string()) = $soortWork"/>
               <xsl:otherwise>
                  <xsl:value-of select="concat(normalize-space(data:ExpressionIdentificatie/data:soortWork/./string()), ' ')"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$controle = ''"/>
         <xsl:otherwise>{"code": "BHKV1027", "id": "<xsl:text/>
            <xsl:value-of select="normalize-space(replace($controle, ' /', ', /'))"/>
            <xsl:text/>", "melding": "Het geleverde regelingversie heeft als soortWork '<xsl:text/>
            <xsl:value-of select="normalize-space(replace($controle, ' /', ', /'))"/>
            <xsl:text/>'. Dit moet voor een tijdelijk regelingdeel zijn '/join/id/stop/work_021'.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_022RegelingTijdelijkdeel moet isTijdelijkDeelVan hebben-->
   <!--RULE -->
   <xsl:template match="data:ExpressionIdentificatie[normalize-space(data:soortWork/./string()) = '/join/id/stop/work_021']"
                 priority="1000"
                 mode="M11">
      <xsl:variable name="eId" select="data:FRBRExpression/./string()"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="data:isTijdelijkDeelVan"/>
         <xsl:otherwise>{"code": "BHKV1028", "eId": "<xsl:text/>
            <xsl:value-of select="$eId"/>
            <xsl:text/>", "melding": "De RegelingTijdelijkdeel met expressionID '<xsl:text/>
            <xsl:value-of select="$eId"/>
            <xsl:text/>' heeft geen isTijdelijkDeelVan. Pas dit aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_009eId van BeoogdeRegeling in Besluit-->
   <!--RULE -->
   <xsl:template match="data:BeoogdeRegeling[data:eId]" priority="1000" mode="M12">
      <xsl:variable name="eId" select="normalize-space(data:eId/./string())"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="(ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@eId = $eId]"/>
         <xsl:otherwise>{"code": "BHKV1009", "eId": "<xsl:text/>
            <xsl:value-of select="$eId"/>
            <xsl:text/>", "melding": "In het besluit of rectificatie is de eId <xsl:text/>
            <xsl:value-of select="$eId"/>
            <xsl:text/> voor de BeoogdeRegeling niet te vinden. Controleer de referentie naar het besluit.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_010eId van Tijdstempel in Besluit-->
   <!--RULE -->
   <xsl:template match="data:ConsolidatieInformatie/data:Tijdstempels/data:Tijdstempel[data:eId]"
                 priority="1000"
                 mode="M13">
      <xsl:variable name="refID" select="normalize-space(data:eId/./string())"/>
      <xsl:variable name="eId">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="starts-with($refID, '!')">
               <xsl:value-of select="substring-after($refID, '#')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$refID"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="component">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="starts-with($refID, '!')">
               <xsl:value-of select="substring-before(translate($refID, '!', ''), '#')"/>
            </xsl:when>
            <xsl:when test="ancestor::tekst:*[@componentnaam][1]">
               <xsl:value-of select="ancestor::tekst:*[@componentnaam][1]/@componentnaam"/>
            </xsl:when>
            <xsl:otherwise>[is_geen_component]</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="           ((ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@eId = $eId][not(ancestor::tekst:*[@componentnaam])] and $component = '[is_geen_component]') or           (ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@componentnaam = $component]//tekst:*[@eId = $eId]"/>
         <xsl:otherwise>{"code": "BHKV1010", "eId": "<xsl:text/>
            <xsl:value-of select="$eId"/>
            <xsl:text/>", "melding": "In het besluit of rectificatie is de eId <xsl:text/>
            <xsl:value-of select="$eId"/>
            <xsl:text/> voor de tijdstempel niet te vinden. Controleer de referentie naar het besluit.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_011eId van data:Intrekking in Besluit-->
   <!--RULE -->
   <xsl:template match="data:ConsolidatieInformatie/data:Intrekkingen/data:Intrekking[data:eId]"
                 priority="1000"
                 mode="M14">
      <xsl:variable name="refID" select="normalize-space(data:eId/./string())"/>
      <xsl:variable name="eId">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="starts-with($refID, '!')">
               <xsl:value-of select="substring-after($refID, '#')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$refID"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="component">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="starts-with($refID, '!')">
               <xsl:value-of select="substring-before(translate($refID, '!', ''), '#')"/>
            </xsl:when>
            <xsl:when test="ancestor::tekst:*[@componentnaam][1]">
               <xsl:value-of select="ancestor::tekst:*[@componentnaam][1]/@componentnaam"/>
            </xsl:when>
            <xsl:otherwise>[is_geen_component]</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="           ((ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@eId = $eId][not(ancestor::tekst:*[@componentnaam])] and $component = '[is_geen_component]') or           ((ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@componentnaam = $component]//tekst:*[@eId = $eId])"/>
         <xsl:otherwise>{"code": "BHKV1011", "eId": "<xsl:text/>
            <xsl:value-of select="$eId"/>
            <xsl:text/>", "melding": "In het besluit of rectificatie is de eId <xsl:text/>
            <xsl:value-of select="$eId"/>
            <xsl:text/> voor de data:Intrekking niet te vinden. Controleer de referentie naar het besluit.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_016wId�van ToelichtingRelatie MOET voorkomen in initieel Besluit-->
   <!--RULE -->
   <xsl:template match="lvbba:BesluitVersie/data:ToelichtingRelaties/data:ToelichtingRelatie/data:toelichtingOp/data:Tekstelement/data:wId"
                 priority="1000"
                 mode="M15">
      <xsl:variable name="wId" select="normalize-space(./string())"/>
      <xsl:variable name="component" select="./../data:component/string()"/>
      <xsl:variable name="aantalkeerwIdinbesluit">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="$component != ''">
               <xsl:value-of select="count(ancestor::lvbba:AanleveringBesluit//tekst:WijzigBijlage/tekst:RegelingCompact[@componentnaam = $component]//tekst:Lichaam//*[@wId = $wId])"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="count(ancestor::lvbba:AanleveringBesluit//tekst:BesluitCompact/tekst:Lichaam//*[@wId = $wId]) + count(ancestor::lvbba:AanleveringBesluit//tekst:BesluitKlassiek/tekst:Lichaam//*[@wId = $wId])"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!--REPORT fout-->
      <xsl:if test="$aantalkeerwIdinbesluit = 0"> {"code": "BHKV1020", "wId": "<xsl:text/>
         <xsl:value-of select="normalize-space($wId)"/>
         <xsl:text/>", "melding": "De wId <xsl:text/>
         <xsl:value-of select="normalize-space($wId)"/>
         <xsl:text/> in toelichtingOp komt niet voor in het besluit, pas dit aan", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_044Een @wordt-versie in een besluit komt overeen met de FRBRExpression
      identificatie-->
   <!--RULE -->
   <xsl:template match="lvbba:AanleveringBesluit//tekst:*[@wordt]"
                 priority="1000"
                 mode="M16">
      <xsl:variable name="wordt" select="normalize-space(@wordt/./string())"/>
      <xsl:variable name="work">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie">
            <xsl:choose>
               <xsl:when test="$wordt = normalize-space(data:ExpressionIdentificatie/data:FRBRExpression/./string())">|GOED|</xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="concat(normalize-space(data:ExpressionIdentificatie/data:FRBRExpression/./string()), ' ')"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="melding">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="contains($work, '|GOED|')"/>
            <xsl:otherwise>
               <xsl:value-of select="$work"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="contains($work, '|GOED|')"/>
         <xsl:otherwise>{"code": "BHKV1044", "id": "<xsl:text/>
            <xsl:value-of select="normalize-space($melding)"/>
            <xsl:text/>", "component": "<xsl:text/>
            <xsl:value-of select="@componentnaam"/>
            <xsl:text/>", "melding": "Er moet versieinformatie meegeleverd worden, deze ontbreekt of is niet correct voor component \"<xsl:text/>
            <xsl:value-of select="@componentnaam"/>
            <xsl:text/>\". Corrigeer de versieinformatie \"<xsl:text/>
            <xsl:value-of select="normalize-space($melding)"/>
            <xsl:text/>\".", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
</xsl:stylesheet>
