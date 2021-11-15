<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            queryBinding="xslt2">
   <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/"/>
   <sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/"/>
   <sch:ns prefix="lvbba"
           uri="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
   <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
   <sch:p>Versie 1.1.0</sch:p>
   <sch:p>Schematron voor aanvullende validaties voor lvbba</sch:p>
   <sch:pattern id="sch_lvbba_003">
      <sch:title>BeoogdInformatieobject in overeenstemming met ExtIoRef/@eId</sch:title>
      <sch:rule context="data:BeoogdInformatieobject/data:eId">
         <sch:let name="data-eId" value="normalize-space(.)"/>
         <sch:let name="joinID"
                  value="normalize-space(parent::data:*/data:instrumentVersie)"/>
         <sch:let name="refs">
            <xsl:for-each select="//tekst:ExtIoRef[not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor::tekst:Verwijder)]">
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
         </sch:let>
         <sch:p>Inhoud van een eId in data:BeoogdInformatieobject MOET als attribuutwaarde van een
        ExtIoRef/@eId vorkomen</sch:p>
         <sch:assert id="BHKV1003" test="$refs/set/id[. = $data-eId]" role="fout">{"code": "BHKV1003", "ref": "<sch:value-of select="$data-eId"/>", "melding": "De eId <sch:value-of select="$data-eId"/> van BeoogdInformatieobject komt niet voor als eId van een ExtIoRef, Controleer de referenties naar de ExtIoRef's", "ernst": "fout"},</sch:assert>
         <sch:p>De identifier voor instrumentVersie MOET overeenkomen met de identitier in
        ExtIoRef</sch:p>
         <sch:assert id="BHKV1036"
                     test="$refs/set/id[. = $data-eId] and $refs/set[id[. = $data-eId]]/join = $joinID"
                     role="fout"> {"code": "BHKV1036", "eId": "<sch:value-of select="$data-eId"/>", "instrument": "<sch:value-of select="$joinID"/>", "melding": "De identifier van instrumentVersie \"<sch:value-of select="$joinID"/>\" komt niet overeen met de ExtIoRef met eId \"<sch:value-of select="$data-eId"/>\". Corrigeer de identifier of de eId zodat deze gelijk zijn.", "ernst": "fout"},</sch:assert>
      </sch:rule>
      <sch:rule context="lvbba:AanleveringBesluit//data:BeoogdInformatieobject[not(data:eId)][data:instrumentVersie]">
         <sch:let name="ID" value="normalize-space(data:instrumentVersie)"/>
         <sch:p>De identifier voor instrumentVersie moet overeenkomen met een identifier in een
        ExtIoRef</sch:p>
         <sch:assert id="BHKV1037"
                     test="ancestor::lvbba:AanleveringBesluit//tekst:ExtIoRef[not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor::tekst:Verwijder)][@ref = $ID]"
                     role="fout"> {"code": "BHKV1037", "id": "<sch:value-of select="$ID"/>", "melding": "De identifier van instrumentVersie \"<sch:value-of select="$ID"/>\" komt niet voor als de join identifier van een ExtIoRef. Controleer de instrumentVersie of voeg een ExtIoRef toe aan de tekst van het besluit.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_004">
      <sch:title>Tijdstempels in ontwerpbesluit</sch:title>
      <sch:rule context="data:BesluitMetadata/data:soortProcedure[normalize-space(./string()) = '/join/id/stop/proceduretype_ontwerp']">
         <sch:p>Voor een ontwerpbesluit MAG GEEN tijdstempel worden meegeleverd</sch:p>
         <sch:report id="BHKV1004"
                     test="ancestor::lvbba:AanleveringBesluit//data:ConsolidatieInformatie/data:Tijdstempels"
                     role="fout"> {"code": "BHKV1004", "melding": "Het ontwerpbesluit heeft tijdstempels, dit is niet toegestaan. Verwijder de tijdstempels.", "ernst": "fout"},</sch:report>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_005">
      <sch:title>Besluit met soort werk '/join/id/stop/work_003'</sch:title>
      <sch:rule context="lvbba:AanleveringBesluit/lvbba:BesluitVersie">
         <sch:let name="soortWork"
                  value="normalize-space(data:ExpressionIdentificatie/data:soortWork/./string())"/>
         <sch:p>De identificatie van het besluit moet als soort werk '/join/id/stop/work_003'
        hebben</sch:p>
         <sch:assert id="BHKV1005"
                     test="$soortWork = '/join/id/stop/work_003'"
                     role="fout">{"code": "BHKV1005", "id": "<sch:value-of select="$soortWork"/>", "melding": "Het geleverde besluit heeft als soortWork '<sch:value-of select="$soortWork"/>' , Dit moet zijn: '/join/id/stop/work_003'.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_006">
      <sch:title>Regeling met soort werk '/join/id/stop/work_019</sch:title>
      <sch:rule context="tekst:RegelingCompact | tekst:RegelingKlassiek | tekst:RegelingVrijetekst">
         <sch:let name="soortWork" value="'/join/id/stop/work_019'"/>
         <sch:let name="controle">
            <xsl:for-each select="ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie">
               <xsl:choose>
                  <xsl:when test="normalize-space(data:ExpressionIdentificatie/data:soortWork/./string()) = $soortWork"/>
                  <xsl:otherwise>
                     <xsl:value-of select="concat(normalize-space(data:ExpressionIdentificatie/data:soortWork/./string()), ' ')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </sch:let>
         <sch:p>De identificatie van een RegelingCompact, RegelingKlassiek of RegelingVrijetekst moet
        als soortWork '/join/id/stop/work_019' hebben</sch:p>
         <sch:assert id="BHKV1006" test="$controle = ''" role="fout">{"code": "BHKV1006", "id": "<sch:value-of select="normalize-space(replace($controle, ' /', ', /'))"/>", "melding": "Het geleverde regelingversie heeft als soortWork '<sch:value-of select="normalize-space(replace($controle, ' /', ', /'))"/>'. Dit moet voor een RegelingCompact, RegelingKlassiek of RegelingVrijetekst zijn '/join/id/stop/work_019'", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_021">
      <sch:title>Regeling met soort werk '/join/id/stop/work_021</sch:title>
      <sch:rule context="tekst:RegelingTijdelijkdeel">
         <sch:let name="soortWork" value="'/join/id/stop/work_021'"/>
         <sch:let name="controle">
            <xsl:for-each select="ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie">
               <xsl:choose>
                  <xsl:when test="normalize-space(data:ExpressionIdentificatie/data:soortWork/./string()) = $soortWork"/>
                  <xsl:otherwise>
                     <xsl:value-of select="concat(normalize-space(data:ExpressionIdentificatie/data:soortWork/./string()), ' ')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </sch:let>
         <sch:p>De identificatie van een RegelingTijdelijkdeel moet als soortWork
        '/join/id/stop/work_021' hebben</sch:p>
         <sch:assert id="BHKV1027" test="$controle = ''" role="fout">{"code": "BHKV1027", "id": "<sch:value-of select="normalize-space(replace($controle, ' /', ', /'))"/>", "melding": "Het geleverde regelingversie heeft als soortWork '<sch:value-of select="normalize-space(replace($controle, ' /', ', /'))"/>'. Dit moet voor een tijdelijk regelingdeel zijn '/join/id/stop/work_021'.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_022">
      <sch:title>RegelingTijdelijkdeel moet isTijdelijkDeelVan hebben</sch:title>
      <sch:rule context="data:ExpressionIdentificatie[normalize-space(data:soortWork/./string()) = '/join/id/stop/work_021']">
         <sch:let name="eId" value="data:FRBRExpression/./string()"/>
         <sch:p>Een RegelingTijdelijkdeel MOET een isTijdelijkDeelVan hebben</sch:p>
         <sch:assert id="BHKV1028" test="data:isTijdelijkDeelVan" role="fout">{"code": "BHKV1028", "eId": "<sch:value-of select="$eId"/>", "melding": "De RegelingTijdelijkdeel met expressionID '<sch:value-of select="$eId"/>' heeft geen isTijdelijkDeelVan. Pas dit aan.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_009">
      <sch:title>eId van BeoogdeRegeling in Besluit</sch:title>
      <sch:rule context="data:BeoogdeRegeling[data:eId]">
         <sch:let name="eId" value="normalize-space(data:eId/./string())"/>
         <sch:p>In BeoogdeRegeling moet de daarin genoemde eId voorkomen in het Besluit</sch:p>
         <sch:assert id="BHKV1009"
                     test="(ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@eId = $eId]"
                     role="fout">{"code": "BHKV1009", "eId": "<sch:value-of select="$eId"/>", "melding": "In het besluit of rectificatie is de eId <sch:value-of select="$eId"/> voor de BeoogdeRegeling niet te vinden. Controleer de referentie naar het besluit.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_010">
      <sch:title>eId van Tijdstempel in Besluit</sch:title>
      <sch:rule context="data:ConsolidatieInformatie/data:Tijdstempels/data:Tijdstempel[data:eId]">
         <sch:let name="refID" value="normalize-space(data:eId/./string())"/>
         <sch:let name="eId">
            <xsl:choose>
               <xsl:when test="starts-with($refID, '!')">
                  <xsl:value-of select="substring-after($refID, '#')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$refID"/>
               </xsl:otherwise>
            </xsl:choose>
         </sch:let>
         <sch:let name="component">
            <xsl:choose>
               <xsl:when test="starts-with($refID, '!')">
                  <xsl:value-of select="substring-before(translate($refID, '!', ''), '#')"/>
               </xsl:when>
               <xsl:when test="ancestor::tekst:*[@componentnaam][1]">
                  <xsl:value-of select="ancestor::tekst:*[@componentnaam][1]/@componentnaam"/>
               </xsl:when>
               <xsl:otherwise>[is_geen_component]</xsl:otherwise>
            </xsl:choose>
         </sch:let>
         <sch:p>In een Tijdstempel moet de daarin genoemde eId voorkomen in het Besluit</sch:p>
         <sch:assert id="BHKV1010"
                     test="           ((ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@eId = $eId][not(ancestor::tekst:*[@componentnaam])] and $component = '[is_geen_component]') or           (ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@componentnaam = $component]//tekst:*[@eId = $eId]"
                     role="fout">{"code": "BHKV1010", "eId": "<sch:value-of select="$eId"/>", "melding": "In het besluit of rectificatie is de eId <sch:value-of select="$eId"/> voor de tijdstempel niet te vinden. Controleer de referentie naar het besluit.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_011">
      <sch:title>eId van data:Intrekking in Besluit</sch:title>
      <sch:rule context="data:ConsolidatieInformatie/data:Intrekkingen/data:Intrekking[data:eId]">
         <sch:let name="refID" value="normalize-space(data:eId/./string())"/>
         <sch:let name="eId">
            <xsl:choose>
               <xsl:when test="starts-with($refID, '!')">
                  <xsl:value-of select="substring-after($refID, '#')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$refID"/>
               </xsl:otherwise>
            </xsl:choose>
         </sch:let>
         <sch:let name="component">
            <xsl:choose>
               <xsl:when test="starts-with($refID, '!')">
                  <xsl:value-of select="substring-before(translate($refID, '!', ''), '#')"/>
               </xsl:when>
               <xsl:when test="ancestor::tekst:*[@componentnaam][1]">
                  <xsl:value-of select="ancestor::tekst:*[@componentnaam][1]/@componentnaam"/>
               </xsl:when>
               <xsl:otherwise>[is_geen_component]</xsl:otherwise>
            </xsl:choose>
         </sch:let>
         <sch:p>In een Intrekking moet de daarin genoemde eId voorkomen in het Besluit</sch:p>
         <sch:assert id="BHKV1011"
                     test="           ((ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@eId = $eId][not(ancestor::tekst:*[@componentnaam])] and $component = '[is_geen_component]') or           ((ancestor::lvbba:AanleveringBesluit | ancestor::lvbba:AanleveringRectificatie)//tekst:*[@componentnaam = $component]//tekst:*[@eId = $eId])"
                     role="fout">{"code": "BHKV1011", "eId": "<sch:value-of select="$eId"/>", "melding": "In het besluit of rectificatie is de eId <sch:value-of select="$eId"/> voor de data:Intrekking niet te vinden. Controleer de referentie naar het besluit.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_016">
      <sch:title>wId�van ToelichtingRelatie MOET voorkomen in initieel Besluit</sch:title>
      <sch:rule context="lvbba:BesluitVersie/data:ToelichtingRelaties/data:ToelichtingRelatie/data:toelichtingOp/data:Tekstelement/data:wId">
         <sch:let name="wId" value="normalize-space(./string())"/>
         <sch:let name="component" value="./../data:component/string()"/>
         <sch:let name="aantalkeerwIdinbesluit">
            <xsl:choose>
               <xsl:when test="$component != ''">
                  <xsl:value-of select="count(ancestor::lvbba:AanleveringBesluit//tekst:WijzigBijlage/tekst:RegelingCompact[@componentnaam = $component]//tekst:Lichaam//*[@wId = $wId])"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="count(ancestor::lvbba:AanleveringBesluit//tekst:BesluitCompact/tekst:Lichaam//*[@wId = $wId]) + count(ancestor::lvbba:AanleveringBesluit//tekst:BesluitKlassiek/tekst:Lichaam//*[@wId = $wId])"/>
               </xsl:otherwise>
            </xsl:choose>
         </sch:let>
         <sch:report id="BHKV1020" test="$aantalkeerwIdinbesluit = 0" role="fout"> {"code": "BHKV1020", "wId": "<sch:value-of select="normalize-space($wId)"/>", "melding": "De wId <sch:value-of select="normalize-space($wId)"/> in toelichtingOp komt niet voor in het besluit, pas dit aan", "ernst": "fout"},</sch:report>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_lvbba_044">
      <sch:title>Een @wordt-versie in een besluit komt overeen met de FRBRExpression
      identificatie</sch:title>
      <sch:rule context="lvbba:AanleveringBesluit//tekst:*[@wordt]">
         <sch:let name="wordt" value="normalize-space(@wordt/./string())"/>
         <sch:let name="work">
            <xsl:for-each select="ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie">
               <xsl:choose>
                  <xsl:when test="$wordt = normalize-space(data:ExpressionIdentificatie/data:FRBRExpression/./string())">|GOED|</xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="concat(normalize-space(data:ExpressionIdentificatie/data:FRBRExpression/./string()), ' ')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </sch:let>
         <sch:let name="melding">
            <xsl:choose>
               <xsl:when test="contains($work, '|GOED|')"/>
               <xsl:otherwise>
                  <xsl:value-of select="$work"/>
               </xsl:otherwise>
            </xsl:choose>
         </sch:let>
         <sch:p>Een @wordt-versie in een besluit is gelijk aan de meegeleverde FRBRExpression
        identificatie</sch:p>
         <sch:assert id="BHKV1044" test="contains($work, '|GOED|')" role="fout">{"code": "BHKV1044", "id": "<sch:value-of select="normalize-space($melding)"/>", "component": "<sch:value-of select="@componentnaam"/>", "melding": "Er moet versieinformatie meegeleverd worden, deze ontbreekt of is niet correct voor component \"<sch:value-of select="@componentnaam"/>\". Corrigeer de versieinformatie \"<sch:value-of select="normalize-space($melding)"/>\".", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>
