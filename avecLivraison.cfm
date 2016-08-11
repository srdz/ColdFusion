<cfsetting showdebugoutput="false" requesttimeout="5000">

<cfif isDefined("FORM.cco")>
	<cfparam name="livraisonNo" type="numeric" default="1">

	<cfquery name="QgetAvecLivraisons" datasource="Fleet">
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
	<cfif "#rtrim(FORM.cco)#" neq "">
		AND p.DEALERSHIPNUM = '#rtrim(FORM.cco)#'
	</cfif>
		AND u.UNITE IS NOT NULL
		AND u.LivraisonID != ''
	</cfquery>

	<cfoutput>
		<table class="table table-striped table-bordered" cellspacing="0" width="100%" id="tblAvecLivraison">
			<thead>
				<tr>
					<th>N&deg; Livraison</th>
					<th>Date de livraison</th>
					<th>Plaque</th>
					<th>S&eacute;rie</th>
					<th>Ann&eacute;e</th>
					<th>Marque</th>
					<th>Mod&egrave;le</th>
					<th>Couleur</th>
					<th>Classe</th>
					<th>Prix</th>
					<th>Type d'achat</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="QgetAvecLivraisons">
					<tr>
						<td align="center">#LIVRAISONID_UNITES# <a href="print_commande.cfm?poid=#ID_PO#&livr=#LIVRAISONID_UNITES#" target="_blank"><img src="/images/print.gif" border="0"></a></td>
						<td>#dateFormat(LIVRAISON_UNITES, 'dd/mm/yyyy')#</td>
						<td>#PLAQUE_UNITES#</td>
						<td>#SERIE_UNITES#</td>
						<td>#CARYEAR_TEMPLATES#</td>
						<td>#MAKE_TEMPLATES#</td>
						<td>#MODEL_TEMPLATES#</td>
						<td>#COLOR_EXT_1_UNITES#</td>
						<td>#CLASS_TEMPLATES#</td>
						<td>#PRICE_INVOICE_TEMPLATES#</td>
						<td>#TYPE_ACHAT_TEMPLATES#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</cfoutput>	
</cfif>

<script type="text/javascript">
	$(document).ready(function() {
		$('#cco').select2();

		$('#tblAvecLivraison').DataTable({
			"paging": true,
			"ordering": false,
			"info": false
		});
	});
</script>
