<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:my="functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie">
   <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" standalone="yes"/>
   <xsl:strip-space elements="*"/>

   <xsl:param name="base.dir" select="string('file:/C:/Werkbestanden/Geonovum/KOOP/Bruidsschat/1.0.3/temp')"/>
   <xsl:param name="waardelijsten" select="document('waardelijsten 1.0.3.xml')//waardelijst"/>

   <xsl:param name="find" select="('gm9999','ws9999','Activiteit','Gebied','Gebiedengroep','Regeltekst')"/>
   <xsl:param name="replace" select="($idBevoegdGezag,$idBevoegdGezag,'activiteit','gebied','gebiedengroep','regeltekst')"/>

   <!-- Haal alle bestanden binnen -->

   <xsl:variable name="FRBRWork" select="fn:collection(concat($base.dir,'?select=*.xml'))/wId2JuriConnect/ExpressionIdentificatie/FRBRWork"/>
   <xsl:variable name="FRBRExpression" select="fn:collection(concat($base.dir,'?select=*.xml'))/wId2JuriConnect/ExpressionIdentificatie/FRBRExpression"/>
   <xsl:variable name="wId2JuriconnectId">
      <xsl:for-each-group select="fn:collection(concat($base.dir,'?select=*.xml'))/wId2JuriConnect/Mapping[contains(wId,'art_')]" group-by="tokenize(wId,'__')[contains(.,'art_')]">
         <xsl:for-each select="current-group()[ends-with(wId,current-grouping-key())]">
            <xsl:element name="artikel">
               <xsl:attribute name="wId" select="wId"/>
               <xsl:attribute name="juriconnectId" select="juriconnectId"/>
               <xsl:for-each select="current-group()[not(ends-with(wId,current-grouping-key()))]">
                  <xsl:element name="lid">
                     <xsl:attribute name="wId" select="wId"/>
                     <xsl:attribute name="juriconnectId" select="juriconnectId"/>
                  </xsl:element>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each-group>
   </xsl:variable>
   <xsl:variable name="owRegeltekst" select="fn:collection(concat($base.dir,'?select=*.xml'))//*[parent::Pseudoregeltekst]"/>
   <xsl:variable name="owActiviteit" select="fn:collection(concat($base.dir,'?select=*.xml'))//rol:Activiteit"/>
   <xsl:variable name="owLocatie" select="fn:collection(concat($base.dir,'?select=*.xml'))//(l:Gebied|l:Gebiedengroep)"/>

   <xsl:variable name="idBevoegdGezag" select="fn:tokenize($FRBRWork,'/')[5]"/>
   <xsl:variable name="idLevering" select="fn:string-join(($idBevoegdGezag,format-date(current-date(),'[Y0001]-[M01]-[D01]')),'_')"/>

   <xsl:template match="/">

      <!-- maak log.txt -->
      <xsl:result-document encoding="Windows-1252" href="../opdracht/log.txt" method="text">
         <!-- controle op ontbrekende juriconnectId's -->
         <xsl:variable name="check">
            <xsl:for-each select="$owRegeltekst">
               <xsl:variable name="id" select="@juriconnectId"/>
               <xsl:if test="not($wId2JuriconnectId//(artikel,lid)[@juriconnectId eq $id])">
                  <xsl:element name="item">
                     <xsl:value-of select="$id"/>
                  </xsl:element>
               </xsl:if>
            </xsl:for-each>
         </xsl:variable>
         <xsl:value-of select="concat('[Controle op ontbrekende juriconnectId''s]','&#10;')"/>
         <xsl:choose>
            <xsl:when test="$check/item">
               <xsl:value-of select="concat('Er zijn ',count($check/item),' fouten gevonden in de mapping tussen wId en juriconnectId:','&#10;')"/>
               <xsl:for-each select="$check/item">
                  <xsl:value-of select="concat(position(),': juriconnectId ''',.,''' ontbreekt in de mapping.','&#10;')"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat('Er zijn geen fouten gevonden in de mapping tussen wId en juriconnectId.','&#10;')"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:value-of select="string('&#10;')"/>
         <!-- controle op ontbrekende pseudo-activiteiten -->
         <xsl:variable name="check">
            <xsl:for-each select="fn:distinct-values($owRegeltekst[$wId2JuriconnectId//(artikel[not(lid)],lid)]/Annotatie/Activiteit)">
               <xsl:variable name="id" select="."/>
               <xsl:if test="not(fn:index-of(fn:distinct-values($owActiviteit/rol:identificatie),$id))">
                  <xsl:element name="item">
                     <xsl:value-of select="my:id($id)"/>
                  </xsl:element>
               </xsl:if>
            </xsl:for-each>
         </xsl:variable>
         <xsl:value-of select="concat('[Controle op ontbrekende pseudo-activiteiten]','&#10;')"/>
         <xsl:choose>
            <xsl:when test="$check/item">
               <xsl:value-of select="concat('Er zijn ',count($check/item),' pseudo-activiteiten gevonden die niet voorkomen in owActiviteit.xml:','&#10;')"/>
               <xsl:for-each select="$check/item">
                  <xsl:value-of select="concat(position(),': Pseudo-activiteit ''',.,''' ontbreekt in owActiviteit.xml.','&#10;')"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat('Alle pseudo-activiteiten komen voor in owActiviteit.xml.','&#10;')"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:value-of select="string('&#10;')"/>
         <!-- controle op activiteiten die gekoppeld zijn aan artikelen met onderliggende leden -->
         <xsl:variable name="check">
            <xsl:for-each select="$wId2JuriconnectId/artikel[lid]">
               <xsl:variable name="id" select="."/>
               <xsl:if test="$owRegeltekst[@juriconnectId=$id/@juriconnectId]">
                  <xsl:for-each select="$owRegeltekst[@juriconnectId=$id/@juriconnectId]/Annotatie">
                     <xsl:element name="item">
                        <xsl:attribute name="wId" select="my:id($id/@wId)"/>
                        <xsl:value-of select="my:id(Activiteit)"/>
                     </xsl:element>
                  </xsl:for-each>
               </xsl:if>
            </xsl:for-each>
         </xsl:variable>
         <xsl:value-of select="concat('[Controle op activiteiten die gekoppeld zijn aan artikelen met onderliggende leden]','&#10;')"/>
         <xsl:choose>
            <xsl:when test="$check/item">
               <xsl:value-of select="concat('Er zijn ',count($check/item),' activiteiten gevonden die niet opgenomen kunnen worden in owRegeltekst.xml, omdat het artikel onderliggende leden bevat:','&#10;')"/>
               <xsl:for-each select="$check/item">
                  <xsl:value-of select="concat(position(),': rol:Activiteit ''',.,''' ontbreekt in owRegeltekst.xml. De activiteit is gekoppeld aan artikel r:Regeltekst ''',./@wId,'''.','&#10;')"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat('Er zijn geen activiteiten gevonden die niet opgenomen kunnen worden in owRegeltekst.xml, omdat het artikel onderliggende leden bevat.','&#10;')"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:value-of select="string('&#10;')"/>
         <!-- controle op ontbrekende waarden in de waardelijsten -->
         <xsl:variable name="check">
            <xsl:for-each select="$owActiviteit">
               <xsl:variable name="id" select="rol:groep"/>
               <xsl:if test="not($waardelijsten[titel='Activiteitengroep']/waarden/waarde[uri=$id])">
                  <xsl:element name="item">
                     <xsl:attribute name="id" select="my:id(rol:identificatie)"/>
                     <xsl:value-of select="rol:groep"/>
                  </xsl:element>
               </xsl:if>
            </xsl:for-each>
         </xsl:variable>
         <xsl:value-of select="concat('[Controle op ontbrekende waarden in de waardelijsten]','&#10;')"/>
         <xsl:choose>
            <xsl:when test="$check/item">
               <xsl:value-of select="concat('Er zijn ',count($check/item),' waarden gevonden die ontbreken in de waardelijst ''Activiteitengroep'':','&#10;')"/>
               <xsl:for-each select="$check/item">
                  <xsl:value-of select="concat(position(),': waarde ''',.,''' ontbreekt in owActiviteit.xml. De waarde komt voor in rol:Activiteit ''',./@id,'''.','&#10;')"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat('Alle waarden komen voor in de waardelijsten.','&#10;')"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:value-of select="string('&#10;')"/>
         <!-- controle op ontbrekende verwijzingen -->
         <xsl:variable name="check">
            <xsl:for-each select="$owActiviteit">
               <xsl:variable name="ref" select="rol:bovenliggendeActiviteit/rol:ActiviteitRef/@xlink:href"/>
               <xsl:if test="not($owActiviteit[rol:identificatie=$ref])">
                  <xsl:element name="item">
                     <xsl:attribute name="id" select="my:id(rol:identificatie)"/>
                     <xsl:value-of select="$ref"/>
                  </xsl:element>
               </xsl:if>
            </xsl:for-each>
         </xsl:variable>
         <xsl:value-of select="concat('[Controle op ontbrekende verwijzingen]','&#10;')"/>
         <xsl:choose>
            <xsl:when test="$check/item">
               <xsl:value-of select="concat('Er zijn ',count($check/item),' verwijzingen gevonden die ontbreken in owActiviteit.xml:','&#10;')"/>
               <xsl:for-each select="$check/item">
                  <xsl:value-of select="concat(position(),': verwijzing ''',.,''' ontbreekt in rol:Activiteit ',./@id,'.','&#10;')"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat('Alle verwijzingen komen voor.','&#10;')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:result-document>

      <!-- owRegeltekst -->
      <xsl:result-document encoding="UTF-8" href="owRegeltekst.xml" indent="yes" method="xml" version="1.0">
         <xsl:element name="ow-dc:owBestand">
            <xsl:copy-of select="//namespace::*"/>
            <xsl:attribute name="xsi:schemaLocation" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.2/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
            <xsl:element name="sl:standBestand">
               <xsl:element name="sl:dataset">
                  <xsl:value-of select="$idBevoegdGezag"/>
               </xsl:element>
               <xsl:element name="sl:inhoud">
                  <xsl:element name="sl:gebied">
                     <xsl:value-of select="$idBevoegdGezag"/>
                  </xsl:element>
                  <xsl:element name="sl:leveringsId">
                     <xsl:value-of select="$idLevering"/>
                  </xsl:element>
                  <xsl:element name="sl:objectTypen">
                     <xsl:for-each select="('Regeltekst','RegelVoorIedereen')">
                        <xsl:element name="sl:objectType">
                           <xsl:value-of select="."/>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:element>
               <!-- verwerk alle juriconnectId's -->
               <xsl:for-each select="$wId2JuriconnectId//(artikel[not(lid)],lid)">
                  <xsl:variable name="id" select="."/>
                  <xsl:variable name="id.regeltekst" select="fn:string-join(('nl.imow',fn:string-join(($idBevoegdGezag,'regeltekst',concat('2020',fn:format-number(count((.,preceding::artikel[not(lid)],preceding::lid)),'000000'))),'.')),'-')"/>
                  <xsl:variable name="id.juridischeregel" select="fn:string-join(('nl.imow',fn:string-join(($idBevoegdGezag,'juridischeregel',concat('2020',fn:format-number(count((.,preceding::artikel[not(lid)],preceding::lid)),'000000'))),'.')),'-')"/>
                  <!-- de eerste gebiedengroep in owLocatie moet het ambtsgebied zijn -->
                  <!--
                  <xsl:variable name="id.locatie" select="$owLocatie/self::l:Gebiedengroep[1]/l:identificatie"/>
                  -->
                  <xsl:variable name="id.locatie" select="fn:string-join(('nl.imow',fn:string-join(($idBevoegdGezag,'gebied','ambtsgebied'),'.')),'-')"/>
                  <xsl:element name="sl:stand">
                     <xsl:element name="ow-dc:owObject">
                        <xsl:element name="r:Regeltekst">
                           <xsl:attribute name="wId" select="$id/@wId"/>
                           <xsl:element name="r:identificatie">
                              <xsl:value-of select="$id.regeltekst"/>
                           </xsl:element>
                        </xsl:element>
                     </xsl:element>
                  </xsl:element>
                  <xsl:element name="sl:stand">
                     <xsl:element name="ow-dc:owObject">
                        <xsl:element name="r:RegelVoorIedereen">
                           <xsl:element name="r:identificatie">
                              <xsl:value-of select="$id.juridischeregel"/>
                           </xsl:element>
                           <xsl:element name="r:idealisatie">
                              <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/idealisatie/id/concept/Exact')"/>
                           </xsl:element>
                           <xsl:element name="r:artikelOfLid">
                              <xsl:element name="r:RegeltekstRef">
                                 <xsl:attribute name="xlink:href" select="$id.regeltekst"/>
                              </xsl:element>
                           </xsl:element>
                           <xsl:element name="r:locatieaanduiding">
                              <xsl:element name="l:LocatieRef">
                                 <xsl:attribute name="xlink:href" select="$id.locatie"/>
                              </xsl:element>
                           </xsl:element>
                        </xsl:element>
                     </xsl:element>
                  </xsl:element>
                  <xsl:if test="$owRegeltekst[@juriconnectId=$id/@juriconnectId]">
                     <xsl:for-each select="$owRegeltekst[@juriconnectId=$id/@juriconnectId]/Annotatie">
                        <xsl:element name="sl:stand">
                           <xsl:element name="ow-dc:owObject">
                              <xsl:element name="r:RegelVoorIedereen">
                                 <xsl:element name="r:identificatie">
                                    <xsl:value-of select="$id.juridischeregel"/>
                                 </xsl:element>
                                 <xsl:element name="r:idealisatie">
                                    <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/idealisatie/id/concept/Exact')"/>
                                 </xsl:element>
                                 <xsl:element name="r:artikelOfLid">
                                    <xsl:element name="r:RegeltekstRef">
                                       <xsl:attribute name="xlink:href" select="$id.regeltekst"/>
                                    </xsl:element>
                                 </xsl:element>
                                 <xsl:element name="r:locatieaanduiding">
                                    <xsl:element name="l:LocatieRef">
                                       <!-- Britt vraagt na of de locatie in pseudo-owLocaties.xml leidend is of in pseudo-owRegeltekst.xml -->
                                       <xsl:attribute name="xlink:href" select="my:id(Locatie)"/>
                                    </xsl:element>
                                 </xsl:element>
                                 <xsl:choose>
                                    <xsl:when test="Activiteit">
                                       <xsl:variable name="id.activiteit" select="Activiteit"/>
                                       <xsl:variable name="index.activiteit" select="count(.|preceding::Activiteit)"/>
                                       <xsl:element name="r:activiteitaanduiding">
                                          <xsl:element name="rol:ActiviteitRef">
                                             <xsl:attribute name="xlink:href" select="my:id($id.activiteit)"/>
                                          </xsl:element>
                                          <xsl:element name="r:ActiviteitLocatieaanduiding">
                                             <xsl:element name="r:identificatie">
                                                <xsl:value-of select="fn:string-join(('nl.imow',fn:string-join(($idBevoegdGezag,'activiteitlocatieaanduiding',concat('2020',fn:format-number($index.activiteit,'000000'))),'.')),'-')"/>
                                             </xsl:element>
                                             <xsl:element name="r:activiteitregelkwalificatie">
                                                <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/activiteitregelkwalificatie/id/concept/AndersGeduid')"/>
                                             </xsl:element>
                                             <xsl:element name="r:locatieaanduiding">
                                                <xsl:element name="l:LocatieRef">
                                                   <xsl:attribute name="xlink:href" select="my:id($owActiviteit[rol:identificatie=$id.activiteit]/rol:locatieaanduiding/l:LocatieRef/@xlink:href)"/>
                                                </xsl:element>
                                             </xsl:element>
                                          </xsl:element>
                                       </xsl:element>
                                    </xsl:when>
                                    <!-- Hier eventueel andere objecten toevoegen -->
                                 </xsl:choose>
                              </xsl:element>
                           </xsl:element>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:if>
               </xsl:for-each>
            </xsl:element>
         </xsl:element>
      </xsl:result-document>

      <!-- owActiviteit -->
      <xsl:result-document encoding="UTF-8" href="owActiviteit.xml" indent="yes" method="xml" version="1.0">
         <xsl:element name="ow-dc:owBestand">
            <xsl:copy-of select="//namespace::*"/>
            <xsl:attribute name="xsi:schemaLocation" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.2/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
            <xsl:element name="sl:standBestand">
               <xsl:element name="sl:dataset">
                  <xsl:value-of select="$idBevoegdGezag"/>
               </xsl:element>
               <xsl:element name="sl:inhoud">
                  <xsl:element name="sl:gebied">
                     <xsl:value-of select="$idBevoegdGezag"/>
                  </xsl:element>
                  <xsl:element name="sl:leveringsId">
                     <xsl:value-of select="$idLevering"/>
                  </xsl:element>
                  <xsl:element name="sl:objectTypen">
                     <xsl:for-each select="('Activiteit')">
                        <xsl:element name="sl:objectType">
                           <xsl:value-of select="."/>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:element>
               <xsl:for-each select="$owActiviteit">
                  <xsl:variable name="id.activiteit" select="my:id(rol:identificatie)"/>
                  <xsl:element name="sl:stand">
                     <xsl:element name="ow-dc:owObject">
                        <xsl:element name="rol:Activiteit">
                           <xsl:element name="rol:identificatie">
                              <xsl:value-of select="$id.activiteit"/>
                           </xsl:element>
                           <xsl:element name="rol:naam">
                              <xsl:value-of select="rol:naam"/>
                           </xsl:element>
                           <xsl:element name="rol:groep">
                              <xsl:value-of select="($waardelijsten[titel='Activiteitengroep']/waarden/waarde[uri=current()/rol:groep]/uri,'http://standaarden.omgevingswet.overheid.nl/activiteit/id/concept/Onbekend')[1]"/>
                           </xsl:element>
                           <xsl:element name="rol:bovenliggendeActiviteit">
                              <xsl:element name="rol:ActiviteitRef">
                                 <xsl:attribute name="xlink:href" select="my:id(rol:bovenliggendeActiviteit/rol:ActiviteitRef/@xlink:href)"/>
                              </xsl:element>
                           </xsl:element>
                        </xsl:element>
                     </xsl:element>
                  </xsl:element>
               </xsl:for-each>
            </xsl:element>
         </xsl:element>
      </xsl:result-document>

      <!-- owRegelingsgebied -->
      <xsl:result-document encoding="UTF-8" href="owRegelingsgebied.xml" indent="yes" method="xml" version="1.0">
         <xsl:element name="ow-dc:owBestand">
            <xsl:copy-of select="//namespace::*"/>
            <xsl:attribute name="xsi:schemaLocation" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.2/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
            <xsl:element name="sl:standBestand">
               <xsl:element name="sl:dataset">
                  <xsl:value-of select="$idBevoegdGezag"/>
               </xsl:element>
               <xsl:element name="sl:inhoud">
                  <xsl:element name="sl:gebied">
                     <xsl:value-of select="$idBevoegdGezag"/>
                  </xsl:element>
                  <xsl:element name="sl:leveringsId">
                     <xsl:value-of select="$idLevering"/>
                  </xsl:element>
                  <xsl:element name="sl:objectTypen">
                     <xsl:for-each select="('Regelingsgebied')">
                        <xsl:element name="sl:objectType">
                           <xsl:value-of select="."/>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:element>
               <xsl:element name="sl:stand">
                  <xsl:element name="ow-dc:owObject">
                     <xsl:element name="rg:Regelingsgebied">
                        <xsl:element name="rg:identificatie">
                           <xsl:value-of select="fn:string-join(('nl.imow',fn:string-join(($idBevoegdGezag,'regelingsgebied','2020000001'),'.')),'-')"/>
                        </xsl:element>
                        <xsl:element name="rg:locatieaanduiding">
                           <xsl:element name="l:LocatieRef">
                              <xsl:attribute name="xlink:href" select="fn:string-join(('nl.imow',fn:string-join(($idBevoegdGezag,'gebied','ambtsgebied'),'.')),'-')"/>
                           </xsl:element>
                        </xsl:element>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:element>
      </xsl:result-document>

      <!-- manifest-ow.xml -->
      <xsl:variable name="namespace" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow')"/>
      <xsl:element name="Aanleveringen" namespace="{$namespace}">
         <xsl:attribute name="xsi:schemaLocation" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow https://register.geostandaarden.nl/xmlschema/tpod/v1.0.2/bestanden-ow/generiek/manifest-ow.xsd')"/>
         <xsl:element name="domein" namespace="{$namespace}">
            <xsl:value-of select="string('omgevingswet')"/>
         </xsl:element>
         <xsl:element name="Aanlevering" namespace="{$namespace}">
            <xsl:element name="WorkIDRegeling" namespace="{$namespace}">
               <xsl:value-of select="$FRBRWork"/>
            </xsl:element>
            <xsl:element name="DoelID" namespace="{$namespace}">
               <xsl:value-of select="concat('/join/id/proces/',$idBevoegdGezag,'/2020/Bruidsschat-InstellingInitieleRegelingVersieDoorRijk')"/>
            </xsl:element>
            <xsl:element name="Bestand" namespace="{$namespace}">
               <xsl:element name="naam" namespace="{$namespace}">
                  <xsl:value-of select="string('owRegeltekst.xml')"/>
               </xsl:element>
               <xsl:for-each select="('Regeltekst','RegelVoorIedereen')">
                  <xsl:element name="objecttype" namespace="{$namespace}">
                     <xsl:value-of select="."/>
                  </xsl:element>
               </xsl:for-each>
            </xsl:element>
            <xsl:element name="Bestand" namespace="{$namespace}">
               <xsl:element name="naam" namespace="{$namespace}">
                  <xsl:value-of select="string('owActiviteit.xml')"/>
               </xsl:element>
               <xsl:for-each select="('Activiteit')">
                  <xsl:element name="objecttype" namespace="{$namespace}">
                     <xsl:value-of select="."/>
                  </xsl:element>
               </xsl:for-each>
            </xsl:element>
            <xsl:element name="Bestand" namespace="{$namespace}">
               <xsl:element name="naam" namespace="{$namespace}">
                  <xsl:value-of select="string('owRegelingsgebied.xml')"/>
               </xsl:element>
               <xsl:for-each select="('Regelingsgebied')">
                  <xsl:element name="objecttype" namespace="{$namespace}">
                     <xsl:value-of select="."/>
                  </xsl:element>
               </xsl:for-each>
            </xsl:element>
         </xsl:element>
      </xsl:element>

   </xsl:template>

   <!-- functies -->

   <xsl:function name="my:id">
      <xsl:param name="id"/>
      <xsl:if test="$id">
         <xsl:variable name="check_id">
            <xsl:for-each select="fn:tokenize(fn:tokenize($id,'-')[2],'\.')">
               <xsl:variable name="index" select="fn:index-of($find,.)"/>
               <node><xsl:value-of select="($replace[$index],.)[1]"/></node>
            </xsl:for-each>
         </xsl:variable>
         <xsl:value-of select="fn:string-join(('nl.imow',fn:string-join($check_id/node,'.')),'-')"/>
      </xsl:if>
   </xsl:function>

</xsl:stylesheet>