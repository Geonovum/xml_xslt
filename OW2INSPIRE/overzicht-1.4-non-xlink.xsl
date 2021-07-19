<?xml version="1.0" encoding="UTF-8"?>
<!-- <plu:pupplementaryRegulation > aa: waarde WORDT <plu:pupplementaryRegulation_aa>waarde <plu:pupplementaryRegulation_aa>  idem <plu:regulationNature> -->
<xsl:stylesheet version="3.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
	xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
	xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:k="http://www.geostandaarden.nl/imow/kaart" xmlns:l="http://www.geostandaarden.nl/imow/locatie"
	xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/"
	xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://mijn.eigen.ns"
	xmlns:ow="http://www.geostandaarden.nl/imow/owobject" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
	xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:sc="http://www.interactive-instruments.de/ShapeChange/AppInfo" xmlns:base2="http://inspire.ec.europa.eu/schemas/base2/2.0" xmlns:gml="http://www.opengis.net/gml/3.2"
	xmlns:plu="http://inspire.ec.europa.eu/schemas/plu/4.0" xmlns:lunom="http://inspire.ec.europa.eu/schemas/lunom/4.0" xmlns:base="http://inspire.ec.europa.eu/schemas/base/3.3"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:ns1="http://www.w3.org/1999/xhtml" xmlns:gss="http://www.isotc211.org/2005/gss"
	xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:ad="http://inspire.ec.europa.eu/schemas/ad/4.0" xmlns:au="http://inspire.ec.europa.eu/schemas/au/4.0"
	xmlns:gn="http://inspire.ec.europa.eu/schemas/gn/4.0" xmlns:bu-base="http://inspire.ec.europa.eu/schemas/bu-base/4.0" xmlns:tn="http://inspire.ec.europa.eu/schemas/tn/4.0"
	xmlns:cp="http://inspire.ec.europa.eu/schemas/cp/4.0" xmlns:net="http://inspire.ec.europa.eu/schemas/net/4.0" xmlns:gmlcov="http://www.opengis.net/gmlcov/1.0"
	xmlns:swe="http://www.opengis.net/swe/2.0" xmlns:hfp="http://www.w3.org/2001/XMLSchema-hasFacetAndProperty" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:al="https://standaarden.overheid.nl/lvbb/stop/aanlevering/" xmlns:ws="https://wimdevries.net"
	xsi:schemaLocation="http://inspire.ec.europa.eu/schemas/plu/4.0 http://inspire.ec.europa.eu/schemas/plu/4.0/PlannedLandUse.xsd http://www.opengis.net/gml/3.2 http://schemas.opengis.net/gml/3.2.1/deprecatedTypes.xsd">

	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:param name="opdracht.dir" select="'opdracht_10'"/>
	<xsl:param name="geometrieIncluded" select="false()" as="xs:boolean"/>
	<xsl:param name="gml2" select="collection(concat('', $opdracht.dir, '?select=*.gml;recurse=yes'))//basisgeo:id"/>
	<xsl:param name="gioos" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//al:InformatieObjectVersie"/>
	<xsl:variable name="locaties" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//l:Gebied, l:Lijn, l:Punt, k:Kaart, p:Pons"/>
	<xsl:variable name="locatieGroepen" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//l:Gebiedengroep, l:Lijnengroep, l:Puntengroep"/>
	<xsl:variable name="gebiedsaanwijzingen" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//ga:Gebiedsaanwijzing"/>
	<xsl:variable name="omgevingsnormen" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//rol:Omgevingsnorm"/>
	<xsl:variable name="omgevingswaarden" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//rol:Omgevingswaarde"/>
	<xsl:variable name="activiteiten" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//rol:Activiteit"/>
	<xsl:variable name="regelteksten" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//r:Regeltekst"/>
	<xsl:variable name="regelVoorIedereen" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//r:RegelVoorIedereen"/>
	<xsl:variable name="instructieregel" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//r:Instructieregel"/>
	<xsl:variable name="omgevingswaarderegel" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//r:Omgevingswaarderegel"/>
	<xsl:variable name="aanleveringBesluit" select="collection(concat('', $opdracht.dir, '?select=*.xml;recurse=yes'))//al:AanleveringBesluit"/>
	<xsl:variable name="OWOP2INSPIREwaardelijsten" select="collection(concat('./', '?select=OWOP2INSPIREwaardelijsten.xml;recurse=yes'))//owop"/>


	<xsl:function name="ws:mapOPOW" as="xs:string">
		<xsl:param name="OPOW" as="xs:string"/>
		<xsl:variable name="insp" as="xs:string"
			select="
				if ($OWOP2INSPIREwaardelijsten[text() eq $OPOW]) then
					$OWOP2INSPIREwaardelijsten[text() eq $OPOW]/../Inspire/text()
				else
					('UNKNOWN')"/>
		<xsl:choose>
			<xsl:when test="$insp eq 'UNKNOWN'">
				<xsl:value-of select="concat('(19) overeenkomende/toe te voegen waarde uit/aan de HSRCL codelist voor: ', $OPOW)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$insp"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<xsl:template match="/">




		<!--maak een lijst van alle locatie(groep)ID's waarmee gezocht gaat worden, ofwel de basis van een pad zijn-->
	
		<xsl:variable name="Index" as="element() *">
			<ws:map>
				<xsl:for-each select="$locatieGroepen">
					<xsl:for-each select="./l:groepselement/(l:GebiedRef | l:PuntRef | l:LijnRef)">
						<xsl:variable name="locatieGroepIdentificatie" select="./../../l:identificatie"/>
						<xsl:variable name="locatieGroepRef" select="string(./@xlink:href)"/>
						<!--l:identificatie vd individuele locatie-->
						<xsl:for-each select="$locaties">
							<!--					locaties in de locatiegroep vinden-->
							<!--koppel de locatieGroepID aan de l:GeometrieRef vd gevonden locatie-->
							<!--de geometrieref van de gevonden locatieID moet aan de locatieGroepID gebonden worden-->
							<!--<xsl:if test="./l:identificatie[text() eq $locatieGroepRef]/text()">-->
							<xsl:if test="./l:identificatie[text() eq $locatieGroepRef]/text()">
								<ws:set>
									<ws:guid>
										<xsl:value-of select="string(./l:geometrie/l:GeometrieRef/@xlink:href)"/>
									</ws:guid>
									<ws:identificatie>
										<xsl:value-of select="$locatieGroepIdentificatie"/>
									</ws:identificatie>
									<!--nu koppeling guid aan de indentificatie van vd locatiegroep-->
								</ws:set>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="$locaties">
					<ws:set>
						<ws:guid>
							<xsl:value-of select="string(./l:geometrie/l:GeometrieRef/@xlink:href)"/>
						</ws:guid>
						<ws:identificatie>
							<xsl:value-of select="./l:identificatie"/>
						</ws:identificatie>
					</ws:set>
				</xsl:for-each>
			</ws:map>
		</xsl:variable>



		<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.gml;recurse=yes'))//basisgeo:Geometrie">

			<xsl:result-document href="{concat('./output/', 'geometry-', string(./basisgeo:id), '.gml')}">
				<xsl:copy-of select="./basisgeo:geometrie/*"/>
					</xsl:result-document>
				
		</xsl:for-each>
		
		
		<!--*************** SupplementaryRegulations ********************-->
		<xsl:variable name="allSupplementaryRegulations">

			<gml:FeatureCollection
				xsi:schemaLocation="http://inspire.ec.europa.eu/schemas/plu/4.0 http://inspire.ec.europa.eu/schemas/plu/4.0/PlannedLandUse.xsd http://www.opengis.net/gml/3.2 http://schemas.opengis.net/gml/3.2.1/deprecatedTypes.xsd">
				<!-- per GML bestand-->
				<xsl:text>&#xA;</xsl:text>
				<xsl:for-each select="collection(concat('', $opdracht.dir, '?select=*.gml;recurse=yes'))//geo:GeoInformatieObjectVaststelling">
					<xsl:variable name="FRBRExpression" select="//geo:FRBRExpression[1]"/>
					<xsl:variable name="achtergrondVerwijzing" select=".//gio:achtergrondVerwijzing[1]"/>
					<xsl:variable name="numberLevel1" select="position()"/>
					<xsl:variable name="naamInformatieObject">
						<xsl:for-each select="$gioos">
							<!--zoek de naamInformatieObject van deze gml, geldt voor alle onderliggende GUIDS-->
							<xsl:if test="$FRBRExpression eq //data:FRBRExpression[1]">
								<xsl:value-of select="//data:naamInformatieObject[1]"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>

					<!--**************** OfficialDocumentation *********************-->
					<!--					<xsl:variable name="OfficialDocumentation">
						<gml:FeatureCollection
							xsi:schemaLocation="http://inspire.ec.europa.eu/schemas/plu/4.0 http://inspire.ec.europa.eu/schemas/plu/4.0/PlannedLandUse.xsd http://www.opengis.net/gml/3.2 http://schemas.opengis.net/gml/3.2.1/deprecatedTypes.xsd">
							<gml:featureMember>
								<plu:OfficialDocumentation gml:id="{concat('officialDocument-', replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '[/;@]', '-' ) )}">
									<plu:inspireId>
										<base:Identifier>
											<base:localId>
												<xsl:value-of select="concat('OfficialDocumentation-', string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]))"/>
											</base:localId>
											<base:namespace>https://standaarden.overheid.nl/stop/imop/data</base:namespace>
										</base:Identifier>
									</plu:inspireId>
									<plu:legislationCitation xlink:href="https://preprod.viewer.dso.kadaster.nl/enmeer"/>
								</plu:OfficialDocumentation>
							</gml:featureMember>
						</gml:FeatureCollection>
					</xsl:variable>-->
					<!--per GUID (geometrie) in gml bestand een:  SupplementaryRegulation van waaruit verschillende sporen lopen naar verschillende rechtsregels-->
					<xsl:for-each select="//basisgeo:id">
						<xsl:variable name="numberLevel2" select="position()"/>
						<xsl:variable name="basisgeo_id" select="."/>
						<xsl:variable name="guid" select="string(.)"/>

						<xsl:variable name="achtergrondVerwijzingstring" select="//gio:achtergrondVerwijzingstring[1]"/>
						<xsl:variable name="achtergrondActualiteit" select="//gio:achtergrondActualiteit[1]"/>


						<!--*********** per elke GUID **********-->

						<ws:container gml:id="{$guid}">
							<xsl:text>&#xA;&#xA;</xsl:text>
							<!-- in de lijst $Index voor de current GUID de betrokkenl:identificatie van locaties én locatiegroepen vinden
									hiermee kunnen de betrokken OW objecten gevonden worden -->
							<xsl:for-each select="$Index/ws:set">
								<xsl:if test="./ws:guid eq $guid">
									<xsl:variable name="numberLevel3" select="position()"/>
									<xsl:variable name="locatieIdentificatie" as="xs:string" select="./ws:identificatie"/>
									<xsl:variable name="nr" select="@ws:nr"/>
									<xsl:text>&#xA;</xsl:text>
									<xsl:comment> (31) Locatie vastgesteld: <xsl:value-of select="$locatieIdentificatie"/> op basis van GUID <xsl:value-of select="./ws:guid"/></xsl:comment>

									<!--Gebiedsaanwijzing > @LocatieRef
Gebiedsaanwijzing < RegelVoorIedereen@GebiedsaanwijzingRef
Gebiedsaanwijzing < Instructieregel@GebiedsaanwijzingRef
Gebiedsaanwijzing < Omgevingswaarderegel@GebiedsaanwijzingRef
ga:groep
ga:type
ga:naam-->

									<!-- *********** betrokken Gebiedsaanwijzingen ***************** -->
									<xsl:for-each select="$gebiedsaanwijzingen//l:LocatieRef[@xlink:href eq $locatieIdentificatie][1]/ancestor::ga:Gebiedsaanwijzing[1]">
										<xsl:variable name="numberLevel4" select="position()"/>
										<xsl:variable name="gebiedsaanwijzing" select="."/>
										<xsl:variable name="naam" select="$gebiedsaanwijzing/ga:naam"/>
										<xsl:variable name="gebiedsaanwijzingIdentificatie" select="string($gebiedsaanwijzing/ga:identificatie)"/>
										<xsl:variable name="groep" select="string($gebiedsaanwijzing/ga:groep)"/>
										<xsl:variable name="type" select="string($gebiedsaanwijzing/ga:type)"/>
										<xsl:variable name="finalType" select="ws:mapOPOW($type)"/>

										<!-- verzamel metadata uit de parent (regelVoorIedereen, instructieregel of omgevingswaarderegel) vd current Gebiedsaanwijzing -->
										<xsl:for-each
											select="($instructieregel, $regelVoorIedereen, $omgevingswaarderegel)/r:gebiedsaanwijzing[ga:GebiedsaanwijzingRef/@xlink:href eq $gebiedsaanwijzingIdentificatie]/(parent::r:RegelVoorIedereen | parent::r:Instructieregel | parent::r:Omgevingswaarderegel)">
											<!--splitsing van paden GUID2reltekst-->
											<xsl:variable name="numberLevel5" select="position()"/>
											<xsl:variable name="regel" select="."/>
											<xsl:variable name="regelIdentificatie" select="$regel/r:identificatie"/>
											<xsl:variable name="ref2Regeltekst" select="string($regel/r:artikelOfLid/r:RegeltekstRef/@xlink:href)"/>
											<xsl:variable name="r_identificatie" select="$regelteksten/r:identificatie[string(self::node()) eq $ref2Regeltekst][1]"/>
											<xsl:variable name="wIdRechtsRegel" select="string($r_identificatie/parent::r:Regeltekst/@wId)"/>
											<xsl:variable name="idealisatie" select="string($regel/r:idealisatie)"/>
											<!--idealisatie waardelijst ‘idealisatie’.-->

											<gml:featureMember xlink:type="simple" xlink:href="{concat('geometry-', $guid, '.gml')}">
												<plu:SupplementaryRegulation
													gml:id="{concat('GA', $guid, replace(string($regelIdentificatie) , '/', '-' ),$numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', $numberLevel5)}">
													<xsl:comment/>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment/>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment/>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment>*************** SPOOR  ***********</xsl:comment>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment>*** Gebiedsaanwijzing: <xsl:value-of select="$gebiedsaanwijzingIdentificatie"/> **</xsl:comment>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment>De actuele gebiedsaanwijzing behoort tot de juridische regel <xsl:value-of select="$regelIdentificatie"/></xsl:comment>
													<xsl:text>&#xA;</xsl:text>
													<plu:specificSupplementaryRegulation/>
													<!--metadata-->
													<plu:processStepGeneral xlink:href="http://inspire.ec.europa.eu/codelist/ProcessStepGeneralValue/legalForce"/>
													<!-- in werking -->
													<plu:backgroundMap>
														<!--TOP10NL geo:GeoInformatieObjectVaststelling//gio:achtergrondVerwijzing-->
														<plu:BackgroundMapValue>
															<plu:backgroundMapDate>2006-05-04T18:13:51.0</plu:backgroundMapDate>
															<plu:backgroundMapReference>
																<xsl:value-of select="$achtergrondVerwijzing"/>
															</plu:backgroundMapReference>
															<plu:backgroudMapURI/>
														</plu:BackgroundMapValue>
													</plu:backgroundMap>
													<plu:beginLifespanVersion>2021-04-19T18:13:51.0</plu:beginLifespanVersion>
													<!-- <plu:dimensionIndication/> -->
													<plu:inspireId>
														<base:Identifier>
															<base:localId>
																<xsl:value-of select="concat($FRBRExpression, $guid)"/>
															</base:localId>
															<base:namespace>http://www.geostandaarden.nl/basisgeometrie/1.0</base:namespace>
														</base:Identifier>
													</plu:inspireId>
													<plu:geometry><xsl:for-each select="$basisgeo_id/../basisgeo:geometrie/gml:MultiSurface">
														<xsl:copy-of select="."/></xsl:for-each></plu:geometry>
													<plu:inheritedFromOtherPlans>false</plu:inheritedFromOtherPlans>
													<plu:specificRegulationNature/>
													<plu:name>
														<xsl:value-of select="$aanleveringBesluit[1]//data:RegelingMetadata/data:officieleTitel"/>
													</plu:name>
													<plu:name>
														<xsl:value-of select="$naam"/>
													</plu:name>
													<xsl:choose>
														<xsl:when test="name($regel) eq 'r:RegelVoorIedereen'">
															<plu:regulationNature>http://inspire.ec.europa.eu/codelist/RegulationNatureValue/generallyBinding</plu:regulationNature>
												</xsl:when>
														<xsl:otherwise>
															<plu:regulationNature>http://inspire.ec.europa.eu/codelist/RegulationNatureValue/bindingOnlyForAuthorities</plu:regulationNature>
														</xsl:otherwise>
													</xsl:choose>
													<!-- <plu:regulationNature xlink:href="http://inspire.ec.europa.eu/codelist/RegulationNatureValue/definedInLegislation"/>
													-typisch voor gebiedsaanwijzing, maar telement mag maar een keer gebruikt worden -->
													<plu:supplementaryRegulation_OPwID><xsl:value-of select="$wIdRechtsRegel"/></plu:supplementaryRegulation_OPwID>
													<xsl:for-each select="$regel/r:thema">
														<plu:supplementaryRegulation_thema><xsl:value-of select="string(.)"/></plu:supplementaryRegulation_thema>
													</xsl:for-each>
													<plu:supplementaryRegulation_type><xsl:value-of select="$finalType"/></plu:supplementaryRegulation_type>
													<plu:supplementaryRegulation_groep><xsl:value-of select="$groep"/></plu:supplementaryRegulation_groep>
													<!--misschien RegelVoorIedereen, etc, maar scope  is onduidelijk-->
													<!--	regulationNature:
											supplementaryRegulation:
											HSRCLcode list, http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue
											p.169/SupplementaryRegulationValue: recommended values & any values defined by data providers-->
													<xsl:variable name="numberLevel5" select="position()"/>

													<plu:officialDocument
														xlink:href="{concat('officialDocument-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', $numberLevel5, replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '[/;@]', '-' ) )}"/>
													<plu:plan
														xlink:href="{concat('SpatialPlan-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', $numberLevel5, replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '/', '-' ) )}"/>
													<!--nog te doen: goede volgorde van SupplementaryRegulation elementen, plu:plan, plu:officialDocument-->
													<!--/meta-->
												</plu:SupplementaryRegulation>
											</gml:featureMember>

											<!-- ***** OfficialDocumentation-->

												<gml:featureMember>
													<plu:OfficialDocumentation
														gml:id="{concat('officialDocument-', 'GA', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', $numberLevel5, replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '[/;@]', '-' ) )}">
														<plu:inspireId>
															<base:Identifier>
																<base:localId>
																	<xsl:value-of
																		select="concat('OfficialDocumentation-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', $numberLevel5, string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]))"
																	/>
																</base:localId>
																<base:namespace>https://standaarden.overheid.nl/stop/imop/data</base:namespace>
															</base:Identifier>
														</plu:inspireId>
														<plu:legislationCitation xlink:href="https://preprod.viewer.dso.kadaster.nl/enmeer"/>
													</plu:OfficialDocumentation>
												</gml:featureMember>
											

											<!--											<xsl:copy-of select="$OfficialDocumentation"/>-->

										</xsl:for-each>
									</xsl:for-each>


									<!--****************	betrokken omgevingsnorm/normwaarde **************-->

									<xsl:for-each select="$omgevingsnormen//l:LocatieRef[@xlink:href eq $locatieIdentificatie]">
										<xsl:variable name="numberLevel4" select="position()"/>
										<!--meerdere omgevingsnormen én refs! -->
										<xsl:variable name="normwaarde" select="./ancestor::rol:Normwaarde[1]"/>
										<!-- verzamel metadata uit de parent omgevingsnorm -->
										<xsl:variable name="Omgevingsnorm" select="$normwaarde/ancestor::rol:Omgevingsnorm[1]"/>
										<xsl:variable name="groep" select="string($Omgevingsnorm/rol:groep[1])"/>
										<xsl:variable name="type" select="string($Omgevingsnorm/rol:type[1])"/>
										<xsl:variable name="finalType" select="ws:mapOPOW($type)"/>
										<xsl:variable name="naam" select="string($Omgevingsnorm/rol:naam[1])"/>
										<xsl:variable name="omgevingsnormIdentificatie" select="string($Omgevingsnorm/rol:identificatie)"/>
										<xsl:variable name="eenheid" select="string($Omgevingsnorm/rol:eenheid)"/>
										<!-- verzamel metadata uit de parent (regelVoorIedereen of instructieregel) vd current omgevingsnorm -->
										<xsl:variable name="regel"
											select="($instructieregel, $regelVoorIedereen)/r:omgevingsnormaanduiding[rol:OmgevingsnormRef/@xlink:href eq $omgevingsnormIdentificatie]/(parent::r:RegelVoorIedereen | parent::r:Instructieregel)"/>
										<xsl:variable name="regelIdentificatie" select="$regel/r:identificatie"/>
										<xsl:variable name="ref2Regeltekst" select="string($regel/r:artikelOfLid/r:RegeltekstRef/@xlink:href)"/>
										<xsl:variable name="r_identificatie" select="$regelteksten/r:identificatie[string(self::node()) eq $ref2Regeltekst][1]"/>
										<xsl:variable name="wIdRechtsRegel" select="string($r_identificatie/parent::r:Regeltekst/@wId)"/>
										<xsl:variable name="idealisatie" select="string($regel/r:idealisatie)"/>
										<!--idealisatie waardelijst ‘idealisatie’.-->
										<xsl:variable name="thema" select="$regel/r:thema"/>
										<gml:featureMember xlink:type="simple" xlink:href="{concat('geometry-', $guid, '.gml')}">
											<plu:SupplementaryRegulation gml:id="{concat('ON', $guid, replace(string($regelIdentificatie) , '/', '-' ),$numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4)}">
												<xsl:comment/>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment/>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment/>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment>*************** SPOOR  ***********</xsl:comment>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment>*** Omgevingsnorm: <xsl:value-of select="$omgevingsnormIdentificatie"/> **</xsl:comment>
												<xsl:text>&#xA;</xsl:text>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment>(28)</xsl:comment>
												<xsl:comment>De actuele Omgevingsnorm behoort bij RegelVoorIedereen/instructieregel (<xsl:value-of select="$regelIdentificatie"/>)</xsl:comment>
												<plu:specificSupplementaryRegulation/>
												<!--metadata-->
												<plu:processStepGeneral xlink:href="http://inspire.ec.europa.eu/codelist/ProcessStepGeneralValue/legalForce"/>
												<!-- in werking -->
												<plu:backgroundMap>
													<!--TOP10NL geo:GeoInformatieObjectVaststelling//gio:achtergrondVerwijzing-->
													<plu:BackgroundMapValue>
														<plu:backgroundMapDate>2006-05-04T18:13:51.0</plu:backgroundMapDate>
														<plu:backgroundMapReference>
															<xsl:value-of select="$achtergrondVerwijzing"/>
														</plu:backgroundMapReference>
														<plu:backgroudMapURI/>
													</plu:BackgroundMapValue>
												</plu:backgroundMap>
												<plu:beginLifespanVersion>2021-04-19T18:13:51.0</plu:beginLifespanVersion>
												<!--eenheid > dimensioning-->
												<xsl:choose>
													<xsl:when test="$normwaarde/rol:kwantitatieveWaarde">
														<plu:dimensioningIndication>
															<plu:DimensioningIndicationMeasureValue>
																<!--http://standaarden.omgevingswet.overheid.nl/typenorm/id/concept/MaximumBouwhoogte 'maximum bouwhoogte bedrijfsgebouw'-->
																<plu:indicationReference><xsl:value-of select="$type"/> '<xsl:value-of select="$naam"/>'</plu:indicationReference>
																<!--<plu:value uom="http://standaarden.omgevingswet.overheid.nl/eenheid/id/concept/Meter">10</plu:value>-->
																<plu:value>
																	<xsl:value-of select="$normwaarde/rol:kwantitatieveWaarde"/>
																</plu:value>
															</plu:DimensioningIndicationMeasureValue>
															<!--zie mapping.html UCUM value mapping met -->
														</plu:dimensioningIndication>
													</xsl:when>
													<xsl:when test="$normwaarde/rol:kwalitatieveWaarde">
														<plu:dimensioningIndication>
															<plu:DimensioningIndicationCharacterValue>
																<plu:indicationReference><xsl:value-of select="$type"/> '<xsl:value-of select="$naam"/>'</plu:indicationReference>
																<plu:value>
																	<xsl:value-of select="$normwaarde/rol:kwalitatieveWaarde"/>
																</plu:value>
															</plu:DimensioningIndicationCharacterValue>
														</plu:dimensioningIndication>
													</xsl:when>
													<xsl:when test="$normwaarde/rol:waardeInRegeltekst">
														<!--‘waarde staat in regeltekst’-->
														<plu:dimensioningIndication>
															<plu:DimensioningIndicationCharacterValue>
																<plu:indicationReference><xsl:value-of select="$type"/> '<xsl:value-of select="$naam"/>'</plu:indicationReference>
																<plu:value>
																	<xsl:value-of select="$normwaarde/rol:waardeInRegeltekst"/>
																</plu:value>
															</plu:DimensioningIndicationCharacterValue>
														</plu:dimensioningIndication>
													</xsl:when>
												</xsl:choose>
												<plu:inspireId>
													<base:Identifier>
														<base:localId>
															<xsl:value-of select="concat($FRBRExpression, $guid)"/>
														</base:localId>
														<base:namespace>http://www.geostandaarden.nl/basisgeometrie/1.0</base:namespace>
													</base:Identifier>
												</plu:inspireId>
												<plu:geometry><xsl:for-each select="$basisgeo_id/../basisgeo:geometrie/gml:MultiSurface">
													<xsl:copy-of select="."/></xsl:for-each></plu:geometry>
												<plu:inheritedFromOtherPlans>false</plu:inheritedFromOtherPlans>
												<plu:specificRegulationNature/>
												<plu:name>
													<xsl:value-of select="$aanleveringBesluit[1]//data:RegelingMetadata/data:officieleTitel"/>
												</plu:name>
												<plu:name>
													<xsl:value-of select="$Omgevingsnorm/rol:naam"/>
												</plu:name>
												<xsl:choose>
													<xsl:when test="name($regel) eq 'r:RegelVoorIedereen'">
														<plu:regulationNature>http://inspire.ec.europa.eu/codelist/RegulationNatureValue/generallyBinding</plu:regulationNature>
													</xsl:when>
													<xsl:otherwise>
														<plu:regulationNature xlink:href="http://inspire.ec.europa.eu/codelist/RegulationNatureValue/bindingOnlyForAuthorities"/>
													</xsl:otherwise>
												</xsl:choose>
												<plu:supplementaryRegulation_OPwID><xsl:value-of select="$wIdRechtsRegel"/></plu:supplementaryRegulation_OPwID>
												<xsl:for-each select="$regel/r:thema">
													<plu:supplementaryRegulation_thema><xsl:value-of select="string(.)"/></plu:supplementaryRegulation_thema>
												</xsl:for-each>
												<plu:supplementaryRegulation_type><xsl:value-of select="$finalType"/></plu:supplementaryRegulation_type>
												<plu:supplementaryRegulation_groep><xsl:value-of select="$groep"/></plu:supplementaryRegulation_groep>


												<!--te doen: Vogende 3 waarden worden tijdens de processing stream gevonden en lokaal neergezet,
								moeten in post processing naar de goede plaats van (hier dus) gebracht worden-->
												<!--misschien RegelVoorIedereen, etc, maar scope  is onduidelijk-->
												<!--							<plu:supplementaryRegulation xlink:arcrole="{Identificatie v OWobject}" xlink:role="uri/naam" xlink:href="http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue/10_OtherSupplementaryRegulation"/>
											regulationNature:
											supplementaryRegulation:
											HSRCLcode list, http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue
											p.169/SupplementaryRegulationValue: recommended values & any values defined by data providers-->
												<!--								<plu:supplementaryRegulation xlink:arcrole="'Identificatie v OWobject'" xlink:role="uri/naam"
									xlink:href="http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue/10_OtherSupplementaryRegulation"/>-->
												<plu:officialDocument xlink:href="{concat('officialDocument-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', $guid, string(generate-id(.)))}"/>
												<plu:plan
													xlink:href="{concat('SpatialPlan-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '/', '-' ) )}"/>
												<!--nog te doen: goede volgorde van SupplementaryRegulation elementen, plu:plan, plu:officialDocument-->
												<!--/meta-->
											</plu:SupplementaryRegulation>
										</gml:featureMember>
										<!-- ***** OfficialDocumentation-->
											<gml:featureMember>
												<plu:OfficialDocumentation
													gml:id="{concat('officialDocument-', 'ON', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-',  replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '[/;@]', '-' ) )}">
													<plu:inspireId>
														<base:Identifier>
															<base:localId>
																<xsl:value-of
																	select="concat('OfficialDocumentation-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]))"
																/>
															</base:localId>
															<base:namespace>https://standaarden.overheid.nl/stop/imop/data</base:namespace>
														</base:Identifier>
													</plu:inspireId>
													<plu:legislationCitation xlink:href="https://preprod.viewer.dso.kadaster.nl/enmeer"/>
												</plu:OfficialDocumentation>
											</gml:featureMember>
										
									</xsl:for-each>


									<!-- *********** betrokken omgevingswaarden ***************** -->
									<!--waarden van de parent rol:Omgevingswaarde-->
									<xsl:for-each select="$omgevingswaarden//l:LocatieRef[@xlink:href eq $locatieIdentificatie]">
										<xsl:variable name="numberLevel4" select="position()"/>
										<!--meerdere omgevingsnormen én refs! -->
										<xsl:variable name="normwaarde" select="./ancestor::rol:Normwaarde[1]"/>
										<!-- verzamel metadata uit de parent omgevingsnorm -->
										<xsl:variable name="Omgevingswaarde" select="$normwaarde/ancestor::rol:Omgevingswaarde[1]"/>
										<xsl:variable name="groep" select="string($Omgevingswaarde/rol:groep[1])"/>
										<xsl:variable name="type" select="string($Omgevingswaarde/rol:type[1])"/>
										<xsl:variable name="finalType" select="ws:mapOPOW($type)"/>
										<xsl:variable name="naam" select="string($Omgevingswaarde/rol:naam[1])"/>
										<xsl:variable name="omgevingswaardeIdentificatie" select="string($Omgevingswaarde/rol:identificatie)"/>
										<xsl:variable name="eenheid" select="string($Omgevingswaarde/rol:eenheid)"/>
										<!-- verzamel metadata uit de parent (regelVoorIedereen of instructieregel) vd current omgevingsnorm -->
										<xsl:variable name="regel" select="$omgevingswaarderegel/r:omgevingswaardeaanduiding[rol:OmgevingswaardeRef/@xlink:href eq $omgevingswaardeIdentificatie]/parent::r:Omgevingswaarderegel"/>
										<xsl:variable name="regelIdentificatie" select="$regel/r:identificatie"/>
										<xsl:variable name="ref2Regeltekst" select="string($regel/r:artikelOfLid/r:RegeltekstRef/@xlink:href)"/>
										<xsl:variable name="r_identificatie" select="$regelteksten/r:identificatie[string(self::node()) eq $ref2Regeltekst][1]"/>
										<xsl:variable name="wIdRechtsRegel" select="string($r_identificatie/parent::r:Regeltekst/@wId)"/>
										<xsl:variable name="idealisatie" select="string($regel/r:idealisatie)"/>
										<!--idealisatie waardelijst ‘idealisatie’.-->
										<xsl:variable name="thema" select="$regel/r:thema"/>
										<gml:featureMember xlink:type="simple" xlink:href="{concat('geometry-', $guid, '.gml')}">
											<plu:SupplementaryRegulation gml:id="{concat('OW', $guid, replace(string($regelIdentificatie) , '/', '-' ),$numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4)}">
												<xsl:comment/>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment/>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment/>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment>*************** SPOOR  ***********</xsl:comment>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment>*** omgevingswaarde: <xsl:value-of select="$omgevingswaardeIdentificatie"/> **</xsl:comment>
												<xsl:text>&#xA;</xsl:text>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment>(28)</xsl:comment>
												<xsl:comment>De actuele omgevingswaarde behoort bij de Omgevingswaarderegel  (<xsl:value-of select="$regelIdentificatie"/>)</xsl:comment>

												<plu:specificSupplementaryRegulation/>
												<!--metadata-->
												<plu:processStepGeneral xlink:href="http://inspire.ec.europa.eu/codelist/ProcessStepGeneralValue/legalForce"/>
												<!-- in werking -->
												<plu:backgroundMap>
													<!--TOP10NL geo:GeoInformatieObjectVaststelling//gio:achtergrondVerwijzing-->
													<plu:BackgroundMapValue>
														<plu:backgroundMapDate>2006-05-04T18:13:51.0</plu:backgroundMapDate>
														<plu:backgroundMapReference>
															<xsl:value-of select="$achtergrondVerwijzing"/>
														</plu:backgroundMapReference>
														<plu:backgroudMapURI/>
													</plu:BackgroundMapValue>
												</plu:backgroundMap>
												<plu:beginLifespanVersion>2021-04-19T18:13:51.0</plu:beginLifespanVersion>
												<!--eenheid > dimensioning-->
												<xsl:choose>
													<xsl:when test="$normwaarde/rol:kwantitatieveWaarde">
														<plu:dimensioningIndication>
															<plu:DimensioningIndicationMeasureValue>
																<!--http://standaarden.omgevingswet.overheid.nl/typenorm/id/concept/MaximumBouwhoogte 'maximum bouwhoogte bedrijfsgebouw'-->
																<plu:indicationReference><xsl:value-of select="$type"/> '<xsl:value-of select="$naam"/>'</plu:indicationReference>
																<!--<plu:value uom="http://standaarden.omgevingswet.overheid.nl/eenheid/id/concept/Meter">10</plu:value>-->
																<plu:value uom="{$eenheid}">
																	<xsl:value-of select="$normwaarde/rol:kwantitatieveWaarde"/>
																</plu:value>
															</plu:DimensioningIndicationMeasureValue>
															<!--zie mapping.html UCUM value mapping met -->
														</plu:dimensioningIndication>
													</xsl:when>
													<xsl:when test="$normwaarde/rol:kwalitatieveWaarde">
														<plu:dimensioningIndication>
															<plu:DimensioningIndicationCharacterValue>
																<plu:indicationReference><xsl:value-of select="$type"/> '<xsl:value-of select="$naam"/>'</plu:indicationReference>
																<plu:value>
																	<xsl:value-of select="$normwaarde/rol:kwalitatieveWaarde"/>
																</plu:value>
															</plu:DimensioningIndicationCharacterValue>
														</plu:dimensioningIndication>
													</xsl:when>
													<xsl:when test="$normwaarde/rol:waardeInRegeltekst">
														<!--‘waarde staat in regeltekst’-->
														<plu:dimensioningIndication>
															<plu:DimensioningIndicationCharacterValue>
																<plu:indicationReference><xsl:value-of select="$type"/> '<xsl:value-of select="$naam"/>'</plu:indicationReference>
																<plu:value>
																	<xsl:value-of select="$normwaarde/rol:waardeInRegeltekst"/>
																</plu:value>
															</plu:DimensioningIndicationCharacterValue>
														</plu:dimensioningIndication>
													</xsl:when>
												</xsl:choose>
												<plu:inspireId>
													<base:Identifier>
														<base:localId>
															<xsl:value-of select="concat($FRBRExpression, $guid)"/>
														</base:localId>
														<base:namespace>http://www.geostandaarden.nl/basisgeometrie/1.0</base:namespace>
													</base:Identifier>
												</plu:inspireId>
												<plu:geometry><xsl:for-each select="$basisgeo_id/../basisgeo:geometrie/gml:MultiSurface">
													<xsl:copy-of select="."/></xsl:for-each></plu:geometry>
												<plu:inheritedFromOtherPlans>false</plu:inheritedFromOtherPlans>
												<plu:specificRegulationNature/>
												<plu:name>
													<xsl:value-of select="$aanleveringBesluit[1]//data:RegelingMetadata/data:officieleTitel"/>
												</plu:name>
												<plu:name>
													<xsl:value-of select="$Omgevingswaarde/rol:naam"/>
												</plu:name>
												<xsl:choose>
													<xsl:when test="name($regel) eq 'r:RegelVoorIedereen'">
														<plu:regulationNature>http://inspire.ec.europa.eu/codelist/RegulationNatureValue/generallyBinding</plu:regulationNature>
													</xsl:when>
													<xsl:otherwise>
														<plu:regulationNature xlink:href="http://inspire.ec.europa.eu/codelist/RegulationNatureValue/bindingOnlyForAuthorities"/>
													</xsl:otherwise>
												</xsl:choose>
												<plu:supplementaryRegulation_OPwID><xsl:value-of select="$wIdRechtsRegel"/></plu:supplementaryRegulation_OPwID>
												<xsl:for-each select="$regel/r:thema">
													<plu:supplementaryRegulation_thema><xsl:value-of select="string(.)"/></plu:supplementaryRegulation_thema>
												</xsl:for-each>
												<plu:supplementaryRegulation_type><xsl:value-of select="$finalType"/></plu:supplementaryRegulation_type>
												<plu:supplementaryRegulation_groep><xsl:value-of select="$groep"/></plu:supplementaryRegulation_groep>

												<!--te doen: Vogende 3 waarden worden tijdens de processing stream gevonden en lokaal neergezet,
								moeten in post processing naar de goede plaats van (hier dus) gebracht worden-->
												<!--misschien RegelVoorIedereen, etc, maar scope  is onduidelijk-->
												<!--							<plu:supplementaryRegulation xlink:arcrole="{Identificatie v OWobject}" xlink:role="uri/naam" xlink:href="http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue/10_OtherSupplementaryRegulation"/>
											regulationNature:
											supplementaryRegulation:
											HSRCLcode list, http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue
											p.169/SupplementaryRegulationValue: recommended values & any values defined by data providers-->
												<!--								<plu:supplementaryRegulation xlink:arcrole="'Identificatie v OWobject'" xlink:role="uri/naam"
									xlink:href="http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue/10_OtherSupplementaryRegulation"/>-->
												<plu:officialDocument xlink:href="{concat('officialDocument-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', $guid, string(generate-id(.)))}"/>
												<plu:plan
													xlink:href="{concat('SpatialPlan-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '/', '-' ) )}"/>
												<!--nog te doen: goede volgorde van SupplementaryRegulation elementen, plu:plan, plu:officialDocument-->
												<!--/meta-->
											</plu:SupplementaryRegulation>
										</gml:featureMember>
										<!-- ***** OfficialDocumentation-->
											<gml:featureMember>
												<plu:OfficialDocumentation
													gml:id="{concat('officialDocument-', 'OW', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-',  replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '[/;@]', '-' ) )}">
													<plu:inspireId>
														<base:Identifier>
															<base:localId>
																<xsl:value-of
																	select="concat('OfficialDocumentation-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]))"
																/>
															</base:localId>
															<base:namespace>https://standaarden.overheid.nl/stop/imop/data</base:namespace>
														</base:Identifier>
													</plu:inspireId>
													<plu:legislationCitation xlink:href="https://preprod.viewer.dso.kadaster.nl/enmeer"/>
												</plu:OfficialDocumentation>
											</gml:featureMember>
									</xsl:for-each>


									<!-- *********** betrokken Activiteiten ***************** 
										NB:heeft zelf geen Locatieaanduiding@LocatieRef!!!
										Gaat via RegelVoorIedereen/activiteitaanduiding/ActiviteitLocatieaanduiding/Locatieaanduiding@LocatieRef

          Activiteit zelf via RegelVoorIedereen/activiteitaanduiding@ActiviteitRef
										
										Onder activiteitaanduiding vind je ook:
										identificatie (waardelijst ‘activiteitregelkwalificatie’)
										activiteitregelkwalificatie
rol:identificatie
rol:naam
rol:groep waardelijst
 -->
									<xsl:for-each select="$regelVoorIedereen/r:activiteitaanduiding/r:ActiviteitLocatieaanduiding/r:locatieaanduiding/l:LocatieRef[@xlink:href eq $locatieIdentificatie]">
										<xsl:variable name="numberLevel4" select="position()"/>
										<!--alles uit RegelVoorIedereen/activiteitaanduiding-->
										<xsl:variable name="juridischeRegel" select="./../../../.."/>
										<!--regelVoorIedereen-->
										<xsl:variable name="ref2Regeltekst" select="string($juridischeRegel/r:artikelOfLid/r:RegeltekstRef/@xlink:href)"/>
										<xsl:variable name="r_identificatie" select="$regelteksten/r:identificatie[string(self::node()) eq $ref2Regeltekst][1]"/>
										<xsl:variable name="wIdRechtsRegel" select="string($r_identificatie/parent::r:Regeltekst/@wId)"/>
										<xsl:variable name="themas" select="$juridischeRegel/r:thema"/>
										<!--thema waardelijst ‘Thema’-->
										<xsl:variable name="activiteitaanduiding" select="./../../.."/>
										<xsl:variable name="ActiviteitLocatieaanduiding" select="./../.."/>
										<xsl:variable name="activiteitregelkwalificatie" select="string($ActiviteitLocatieaanduiding/r:activiteitregelkwalificatie)"/>
										<!--waardelijst ‘activiteitregelkwalificatie’.-->
										<!--alles uit activiteit-->
										<xsl:variable name="activiteit" select="$activiteiten/self::*[string(./rol:identificatie) eq string($activiteitaanduiding/rol:ActiviteitRef/@xlink:href)][1]">
											<!--altijd 1-->
										</xsl:variable>
										<xsl:variable name="activiteitIdentificatie" select="string($activiteit/rol:identificatie)"/>
										<xsl:variable name="naam" select="string($activiteit/rol:naam)"/>
										<xsl:variable name="groep" select="string($activiteit/rol:groep)"/>
										<!--waardelijst ‘Activiteitengroep’-->
										<xsl:variable name="gerelateerdeActiviteit" select="$activiteit/rol:gerelateerdeActiviteit/rol:ActiviteitRef/@xlink:href"/>
										<xsl:variable name="bovenliggendeActiviteit" select="string($activiteit/rol:bovenliggendeActiviteit/rol:ActiviteitRef/@xlink:href)"/>
										<gml:featureMember xlink:type="simple" xlink:href="{concat('geometry-', $guid, '.gml')}">
											<plu:SupplementaryRegulation
												gml:id="{concat('RI', $guid, replace(string($juridischeRegel/r:identificatie) , '/', '-' ), $numberLevel1,  '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4)}">
												<xsl:comment/>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment/>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment/>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment>*************** SPOOR  ***********</xsl:comment>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment>*** activiteit: <xsl:value-of select="$activiteit/rol:identificatie"/> **</xsl:comment>
												<xsl:text>&#xA;</xsl:text>
												<xsl:text>&#xA;</xsl:text>
												<xsl:comment>(28)</xsl:comment>
												<xsl:comment>De actuele activiteit behoort bij de regelVoorIedereen  (<xsl:value-of select="$juridischeRegel/r:identificatie"/>)</xsl:comment>

												<plu:specificSupplementaryRegulation/>
												<!--metadata-->
												<plu:processStepGeneral xlink:href="http://inspire.ec.europa.eu/codelist/ProcessStepGeneralValue/legalForce"/>
												<!-- in werking -->
												<plu:backgroundMap>
													<!--TOP10NL geo:GeoInformatieObjectVaststelling//gio:achtergrondVerwijzing-->
													<plu:BackgroundMapValue>
														<plu:backgroundMapDate>2006-05-04T18:13:51.0</plu:backgroundMapDate>
														<plu:backgroundMapReference>
															<xsl:value-of select="$achtergrondVerwijzing"/>
														</plu:backgroundMapReference>
														<plu:backgroudMapURI/>
													</plu:BackgroundMapValue>
												</plu:backgroundMap>

												<plu:beginLifespanVersion>2021-04-19T18:13:51.0</plu:beginLifespanVersion>
												<!-- <plu:dimensionIndication/> -->
												<plu:inspireId>
													<base:Identifier>
														<base:localId>
															<xsl:value-of select="concat($FRBRExpression, $guid)"/>
														</base:localId>
														<base:namespace>http://www.geostandaarden.nl/basisgeometrie/1.0</base:namespace>
													</base:Identifier>
												</plu:inspireId>
												<plu:geometry><xsl:for-each select="$basisgeo_id/../basisgeo:geometrie/gml:MultiSurface">
													<xsl:copy-of select="."/></xsl:for-each></plu:geometry>
												<plu:inheritedFromOtherPlans>false</plu:inheritedFromOtherPlans>
												<plu:specificRegulationNature/>
												<plu:name>
													<xsl:value-of select="$aanleveringBesluit[1]//data:RegelingMetadata/data:officieleTitel"/>
												</plu:name>
												<plu:name>
													<xsl:value-of select="$naam"/>
												</plu:name>
												<plu:regulationNature>http://inspire.ec.europa.eu/codelist/RegulationNatureValue/generallyBinding</plu:regulationNature>
												<plu:supplementaryRegulation_OPwID><xsl:value-of select="$wIdRechtsRegel"/></plu:supplementaryRegulation_OPwID>
												<xsl:for-each select="$themas">
													<plu:supplementaryRegulation_thema><xsl:value-of select="string(.)"/></plu:supplementaryRegulation_thema>
												</xsl:for-each>
												<plu:supplementaryRegulation_groep><xsl:value-of select="$groep"/></plu:supplementaryRegulation_groep>
												<plu:supplementaryRegulationr_activiteitregelkwalificatie><xsl:value-of select="$activiteitregelkwalificatie"/></plu:supplementaryRegulationr_activiteitregelkwalificatie>

												<!--te doen: Vogende 3 waarden worden tijdens de processing stream gevonden en lokaal neergezet,
								moeten in post processing naar de goede plaats van (hier dus) gebracht worden-->
												<!--misschien RegelVoorIedereen, etc, maar scope  is onduidelijk-->
												<!--							<plu:supplementaryRegulation xlink:arcrole="{Identificatie v OWobject}" xlink:role="uri/naam" xlink:href="http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue/10_OtherSupplementaryRegulation"/>
											regulationNature:
											supplementaryRegulation:
											HSRCLcode list, http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue
											p.169/SupplementaryRegulationValue: recommended values & any values defined by data providers-->
												<!--								<plu:supplementaryRegulation xlink:arcrole="'Identificatie v OWobject'" xlink:role="uri/naam"
									xlink:href="http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue/10_OtherSupplementaryRegulation"/>-->
												<plu:officialDocument xlink:href="{concat('officialDocument-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', $guid, string(generate-id(.)))}"/>
												<plu:plan
													xlink:href="{concat('SpatialPlan-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '/', '-' ) )}"/>
												<!--nog te doen: goede volgorde van SupplementaryRegulation elementen, plu:plan, plu:officialDocument-->
												<!--/meta-->
											</plu:SupplementaryRegulation>
										</gml:featureMember>
										<!-- ***** OfficialDocumentation-->
											<gml:featureMember>
												<plu:OfficialDocumentation
													gml:id="{concat('officialDocument-', 'RI', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-',  replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '[/;@]', '-' ) )}">
													<plu:inspireId>
														<base:Identifier>
															<base:localId>
																<xsl:value-of
																	select="concat('OfficialDocumentation-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]))"
																/>
															</base:localId>
															<base:namespace>https://standaarden.overheid.nl/stop/imop/data</base:namespace>
														</base:Identifier>
													</plu:inspireId>
													<plu:legislationCitation xlink:href="https://preprod.viewer.dso.kadaster.nl/enmeer"/>
												</plu:OfficialDocumentation>
											</gml:featureMember>
									</xsl:for-each>


									<!--								********** RegelVoorIedereens, Instructieregels, Omgevingswaarderegels die *direkt* (zonder OW object annotatie) verwijzen naar de current locatie;
											de enige functie van deze juridische regel is dan het het toekennen van een thema aan de regel en het gebied. 
											de rest van de OW objecten, die via Juridische regel gaan, zijn boven al afgehandeld, dus overslaan
											*********-->
									<xsl:for-each select="$regelVoorIedereen, $instructieregel, $omgevingswaarderegel">
										<xsl:if test=".//l:LocatieRef[@xlink:href eq $locatieIdentificatie]">
											<xsl:variable name="numberLevel4" select="position()"/>
											<!--vooralsnog niet: and empty((./r:gebiedsaanwijzing, ./r:kaartaanduiding, ./r:activiteitaanduiding, ./r:omgevingsnormaanduiding))-->
											<xsl:variable name="juridischeRegelIdentificatie" select="string(./r:identificatie)"/>
											<xsl:variable name="idealisatie" select="string(./r:idealisatie)"/>
											<!--idealisatie waardelijst ‘idealisatie’.-->
											<xsl:variable name="ref2Regeltekst" select="string(./r:artikelOfLid/r:RegeltekstRef/@xlink:href)"/>
											<xsl:variable name="r_identificatie" select="$regelteksten/r:identificatie[string(self::node()) eq $ref2Regeltekst][1]"/>
											<xsl:variable name="wIdRechtsRegel" select="string($r_identificatie/parent::r:Regeltekst/@wId)"/>
											<gml:featureMember xlink:type="simple" xlink:href="{concat('geometry-', $guid, '.gml')}">
												<plu:SupplementaryRegulation
													gml:id="{concat('JR', $guid, replace(string($juridischeRegelIdentificatie) , '/', '-' ),$numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4)}">
													<xsl:comment>o</xsl:comment>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment>o</xsl:comment>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment>o</xsl:comment>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment>*************** SPOOR  ***********</xsl:comment>
													<xsl:text>&#xA;</xsl:text>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment>(22) </xsl:comment>
													<xsl:comment>******************** juridische regel ***************</xsl:comment>
													<xsl:text>&#xA;</xsl:text>
													<xsl:comment>Deze <xsl:value-of select="name(.)"/> gevonden via de *locatieRef* ervan (<xsl:value-of select="$juridischeRegelIdentificatie"/>)</xsl:comment>
													<xsl:text>&#xA;</xsl:text>

													<plu:specificSupplementaryRegulation/>
													<!--metadata-->
													<plu:processStepGeneral xlink:href="http://inspire.ec.europa.eu/codelist/ProcessStepGeneralValue/legalForce"/>
													<!-- in werking -->
													<plu:backgroundMap>
														<!--TOP10NL geo:GeoInformatieObjectVaststelling//gio:achtergrondVerwijzing-->
														<plu:BackgroundMapValue>
															<plu:backgroundMapDate>2006-05-04T18:13:51.0</plu:backgroundMapDate>
															<plu:backgroundMapReference>
																<xsl:value-of select="$achtergrondVerwijzing"/>
															</plu:backgroundMapReference>
															<plu:backgroudMapURI/>
														</plu:BackgroundMapValue>
													</plu:backgroundMap>
													<plu:beginLifespanVersion>2021-04-19T18:13:51.0</plu:beginLifespanVersion>
													<!-- <plu:dimensionIndication/> -->
													<plu:inspireId>
														<base:Identifier>
															<base:localId>
																<xsl:value-of select="concat($FRBRExpression, $guid)"/>
															</base:localId>
															<base:namespace>http://www.geostandaarden.nl/basisgeometrie/1.0</base:namespace>
														</base:Identifier>
													</plu:inspireId>
													<plu:geometry><xsl:for-each select="$basisgeo_id/../basisgeo:geometrie/gml:MultiSurface">
														<xsl:copy-of select="."/></xsl:for-each></plu:geometry>
													<plu:inheritedFromOtherPlans>false</plu:inheritedFromOtherPlans>
													<plu:specificRegulationNature/>
													<plu:name>
														<xsl:value-of select="$aanleveringBesluit[1]//data:RegelingMetadata/data:officieleTitel"/>
													</plu:name>
													<xsl:choose>
														<xsl:when test="name(.) eq 'r:RegelVoorIedereen'">
															<plu:regulationNature>http://inspire.ec.europa.eu/codelist/RegulationNatureValue/generallyBinding</plu:regulationNature>
														</xsl:when>
														<xsl:when test="name(.) eq 'r:Instructieregel'">
															<plu:regulationNature xlink:href="http://inspire.ec.europa.eu/codelist/RegulationNatureValue/bindingOnlyForAuthorities"/>
														</xsl:when>
														<xsl:otherwise>
															<plu:regulationNature xlink:href="http://inspire.ec.europa.eu/codelist/RegulationNatureValue/bindingOnlyForAuthorities"/>
														</xsl:otherwise>
													</xsl:choose>
													<plu:supplementaryRegulation_OPwID><xsl:value-of select="$wIdRechtsRegel"/></plu:supplementaryRegulation_OPwID>
													<xsl:for-each select="./r:thema">
														<plu:supplementaryRegulation_thema><xsl:value-of select="string(.)"/></plu:supplementaryRegulation_thema>
													</xsl:for-each>
													<!--te doen: Vogende 3 waarden worden tijdens de processing stream gevonden en lokaal neergezet,
								moeten in post processing naar de goede plaats van (hier dus) gebracht worden-->
													<!--misschien RegelVoorIedereen, etc, maar scope  is onduidelijk-->
													<!--							<plu:supplementaryRegulation xlink:arcrole="{Identificatie v OWobject}" xlink:role="uri/naam" xlink:href="http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue/10_OtherSupplementaryRegulation"/>
											regulationNature:
											supplementaryRegulation:
											HSRCLcode list, http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue
											p.169/SupplementaryRegulationValue: recommended values & any values defined by data providers-->
													<!--								<plu:supplementaryRegulation xlink:arcrole="'Identificatie v OWobject'" xlink:role="uri/naam"
									xlink:href="http://inspire.ec.europa.eu/codelist/SupplementaryRegulationValue/10_OtherSupplementaryRegulation"/>-->
													<plu:officialDocument xlink:href="{concat('officialDocument-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', $guid, string(generate-id(.)))}"/>
													<plu:plan
														xlink:href="{concat('officialDocument-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '[/;@]', '-' ) )}"/>
													<!--nog te doen: goede volgorde van SupplementaryRegulation elementen, plu:plan, plu:officialDocument-->
													<!--/meta-->
												</plu:SupplementaryRegulation>
											</gml:featureMember>
											<!-- ***** OfficialDocumentation-->
												<gml:featureMember>
													<plu:OfficialDocumentation
														gml:id="{concat('officialDocument-', 'JR', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-',  replace(string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]) , '[/;@]', '-' ) )}">
														<plu:inspireId>
															<base:Identifier>
																<base:localId>
																	<xsl:value-of
																		select="concat('OfficialDocumentation-', $numberLevel1, '-', $numberLevel2, '-', $numberLevel3, '-', $numberLevel4, '-', string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]))"
																	/>
																</base:localId>
																<base:namespace>https://standaarden.overheid.nl/stop/imop/data</base:namespace>
															</base:Identifier>
														</plu:inspireId>
														<plu:legislationCitation xlink:href="https://preprod.viewer.dso.kadaster.nl/enmeer"/>
													</plu:OfficialDocumentation>
												</gml:featureMember>
										</xsl:if>
									</xsl:for-each>


								</xsl:if>
							</xsl:for-each>
						</ws:container>
					</xsl:for-each>
					<!--/per GUID-->
				</xsl:for-each>
			</gml:FeatureCollection>
		</xsl:variable>


		<!--**************** gml:featureMember to file *********************-->
		

		<xsl:result-document href="{concat('output/FeatureCollection', '.gml')}">
			<gml:FeatureCollection	xsi:schemaLocation="http://inspire.ec.europa.eu/schemas/plu/4.0 http://inspire.ec.europa.eu/schemas/plu/4.0/PlannedLandUse.xsd http://www.opengis.net/gml/3.2 http://schemas.opengis.net/gml/3.2.1/deprecatedTypes.xsd">
				<xsl:for-each select="$allSupplementaryRegulations//gml:featureMember">
					<!--plu:SupplementaryRegulation-->
					<xsl:copy-of select="."/>
					<!--				<xsl:copy-of select="./following-sibling::gml:FeatureCollection[1]"/>-->
				</xsl:for-each>
			</gml:FeatureCollection>
		</xsl:result-document>







		<!--**************** SpatialPlan to file *********************-->

		<xsl:variable name="SpatialPlan">
			<gml:FeatureCollection
				xsi:schemaLocation="http://inspire.ec.europa.eu/schemas/plu/4.0 http://inspire.ec.europa.eu/schemas/plu/4.0/PlannedLandUse.xsd http://www.opengis.net/gml/3.2 http://schemas.opengis.net/gml/3.2.1/deprecatedTypes.xsd">

				<gml:featureMember>
					<plu:SpatialPlan gml:id="{concat('SpatialPlan-', string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]))}">
						<plu:inspireId>
							<base:Identifier>
								<base:localId>
									<xsl:value-of select="concat('SpatialPlan-', string($aanleveringBesluit[1]//data:BeoogdeRegeling[1]/data:instrumentVersie[1]))"/>
								</base:localId>
								<base:namespace>https://standaarden.overheid.nl/stop/imop/data</base:namespace>
							</base:Identifier>
						</plu:inspireId>
						<plu:extent/>
						<!--	 <xsl:text>&#xA;</xsl:text><xsl:comment>aggregatie van alle geometriën in SupplementaryRegulation's</xsl:comment>-->
						<plu:beginLifespanVersion>2006-05-04T18:13:51.0</plu:beginLifespanVersion>
						<!--
					in the spatial data set.Date and time at which this version of the spatial object was inserted or changed-->
						<plu:officialTitle>
							<xsl:value-of select="$aanleveringBesluit[1]//data:RegelingMetadata/data:officieleTitel"/>
						</plu:officialTitle>
						<plu:levelOfSpatialPlan xlink:href="http://inspire.ec.europa.eu/codelist/LevelOfSpatialPlanValue/infraRegional"/>
						<!-- handmatig provincie = http://inspire.ec.europa.eu/codelist/LevelOfSpatialPlanValue/infraRegional
	(https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32003R1059&qid=1617806257948)
-->
						<plu:alternativeTitle nilReason="https://inspire.ec.europa.eu/codelist/VoidReasonValue/Unpopulated"/>
						<plu:planTypeName xlink:href="omgevingsverordening"/>
						<!--handmatig: omgevingsverordening, niet in aanlevering te vinden -->
						<plu:BackgroundMapValue nilReason="https://inspire.ec.europa.eu/codelist/VoidReasonValue/Unpopulated"/>
						<!-- NIET voor spatialplan, alleeen voor supplementaryRegulationsTOP10NL geo:GeoInformatieObjectVaststelling//gio:achtergrondVerwijzing-->
						<plu:ordinance>
							<plu:OrdinanceValue>
								<plu:OrdinanceDate/>
								<plu:OrdinanceReference>
									<xsl:value-of select="$aanleveringBesluit[1]//al:RegelingVersieInformatie[1]/data:ExpressionIdentificatie[1]/data:soortWork[1]"/>
								</plu:OrdinanceReference>
							</plu:OrdinanceValue>
							<plu:ordinanceDate/>
							<!--consolidatie:https://standaarden.overheid.nl/stop/imop/consolidatie/juridischWerkendOp-->
						</plu:ordinance>


						<xsl:for-each select="$allSupplementaryRegulations//gml:featureMember/plu:SupplementaryRegulation[1]/@gml:id">
							<!--Links to officialDocuments-->
							<plu:officialDocument xlink:href="XXX TO DO"/>
						</xsl:for-each>
						<xsl:for-each select="$allSupplementaryRegulations//gml:featureMember/plu:SupplementaryRegulation[1]/@gml:id">
							<!--Links to supplementary regulations-->
							<plu:restriction xlink:href="{string(.)}"/>
						</xsl:for-each>
						<!--waarde van <geo:FRBRExpression>/join/id/regdata/pv26/2020/aandachtsgebiedstiltegebied/nld@2020-06-02</geo:FRBRExpression>
	 <basisgeo:id>t66b42fee-0f30-4c36-8712-3c2639a5d66d</basisgeo:id> komt in geometrie gml bestand
	-->
					</plu:SpatialPlan>
				</gml:featureMember>
			</gml:FeatureCollection>
		</xsl:variable>

		<xsl:result-document href="{concat('output/spatialPlan', '.xml')}">
			<xsl:copy-of select="$SpatialPlan"/>
		</xsl:result-document>
	</xsl:template>
	<!--
Activiteit < RegelVoorIedereen@ActiviteitRef
rol:identificatie
rol:naam
rol:groep waardelijst ‘Aactiviteitengroep’
rol:identificatie

Gebiedsaanwijzing > @LocatieRef
Gebiedsaanwijzing < RegelVoorIedereen@GebiedsaanwijzingRef
Gebiedsaanwijzing < Instructieregel@GebiedsaanwijzingRef
Gebiedsaanwijzing < Omgevingswaarderegel@GebiedsaanwijzingRef
ga:groep
ga:type
ga:naam

Omgevingsnorm > @LocatieRef
Omgevingsnorm < RegelVoorIedereen@OmgevingsnormRef
Omgevingsnorm < Instructieregel@OmgevingsnormRef
Omgevingsnorm < Kaart@OmgevingsnormRef (niet)
Normwaarde:
groep
type
eenheid
naam

Omgevingswaarde > @LocatieRef
Omgevingswaarde < Omgevingswaarderegel@OmgevingswaardeRef
groep
type
eenheid
naam
Normwaarde:
groep
type
eenheid
naam


RegelVoorIedereen, Instructieregel, Omgeving:swaarderegel
idealisatie
thema

									-->

	<!--
$allSupplementaryRegulations:
gml:FeatureCollection
loop: GML bestanden
..loop: per GML bestand > GUIDS
....loop: per (locatieID) vd GUID
....gml:featureMember
....ws:container gml:id="{$guid}"
......loop Gebiedsaanwijzingen
......loop omgevingsnormen/normwaarden
......loop omgevingswaarden
......loop Activiteiten
......loop RegelVoorIedereens/Instructieregels/Omgevingswaarderegels
		-->
</xsl:stylesheet>
