<cfsetting showdebugoutput="false" requesttimeout="5000">

<cfif isDefined("FORM.po_id") and (isDefined("FORM.date_livraison") and #FORM.date_livraison# neq "")>
	<cfquery name="QgetPO" datasource="Fleet">
		SELECT 
			p.ID AS ID_PO,
			p.PONUM AS PONUM_PO,
			p.TEMPLATE_ID AS TEMPLATEID_PO,
			p.LIVRAISON AS LIVRAISON_PO,
			p.DEALERSHIPNUM AS DEALERSHIPNUM_PO,
			p.Nom_Concessionaire AS NOM_CONCESSIONNAIRE_PO,
			p.TOT_CARS AS TOT_CARS_PO,
			p.TOT_RECU AS TOT_RECU_PO,
			p.TOT_PRICE AS TOT_PRICE_PO,
			u.ID AS ID_UNITES,
			u.PO_ID AS PO_ID_UNITES,
			u.UNITID AS UNITID_UNITES,
			u.SERIE AS SERIE_UNITES,
			u.UNITE AS UNITE_UNITES,
			u.PLAQUE AS PLAQUE_UNITES,
			u.COLOR_EXT_1 AS COLOR_EXT_1_UNITES,
			u.LIVRAISON AS LIVRAISON_UNITES,
			u.LIVRAISONID AS LIVRAISONID_UNITES,
			u.RECU AS RECU_UNITES,
			u.DELETED AS DELETED_UNITES,
			t.ID AS ID_TEMPLATES,
			t.CARYEAR AS CARYEAR_TEMPLATES,
			t.MAKE AS MAKE_TEMPLATES,
			t.MODEL AS MODEL_TEMPLATES,
			t.CLASS AS CLASS_TEMPLATES,
			t.PRICE_INVOICE AS PRICE_INVOICE_TEMPLATES,
			t.TYPE_ACHAT AS TYPE_ACHAT_TEMPLATES
		FROM PO p
		INNER JOIN Unites u ON (u.PO_ID = p.Id)
		INNER JOIN Templates t ON (t.ID = p.Template_ID)
		WHERE 1=1
	<cfif "#FORM.po_id#" neq "">
		AND u.PO_ID IN (#rtrim(FORM.po_id)#)
	</cfif>
		AND u.UNITE IS NOT NULL
	</cfquery>

	<cfloop query="QgetPO">
		<cfquery name="QgetPrintCommande" datasource="Fleet">
			SELECT * 
			FROM print_commande 
			WHERE PO_ID = #QgetPO.PO_ID_UNITES#
			OR NUM_UNITE = '#QgetPO.UNITE_UNITES#'
		</cfquery>

		<cfif QgetPrintCommande.recordCount eq 0>
			<cfquery name="QinsertLivaison" datasource="Fleet">
				SET NOCOUNT ON
				INSERT INTO LIVRAISONS (
									 	DATE_LIVRAISON,
									 	CREATED_USER
									   )
				VALUES (
						 <cfqueryparam value="#trim(FORM.date_livraison)#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#session.user#" cfsqltype="cf_sql_varchar"> <!--- session tusr --->
					   )
				SELECT @@Identity AS LastestID
				SET NOCOUNT OFF
			</cfquery>
		
			<cfset lastId = #QinsertLivaison.LastestID#>
		
			<cfquery name="QUpdateCommande" datasource="Fleet">
				INSERT INTO print_commande (ID, NUM_UNITE, PO_ID, NUMERO)
				VALUES (#lastId#, '#QgetPO.UNITE_UNITES#', #QgetPO.PO_ID_UNITES#, #QgetPO.ID_UNITES#)
			</cfquery>		

			<cfquery name="QupdateUnites" datasource="Fleet">
				UPDATE Unites
				SET LivraisonID = #lastId#,
					Livraison = '#trim(FORM.date_livraison)#'
				WHERE Id = #QgetPO.ID_UNITES#
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
