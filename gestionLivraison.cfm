<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Gestion des livraisons</title>

		<link rel="icon" type="image/x-icon" href="\images\logo.jpg" />

		<link href="\bootstrap\3.03\css\bootstrap.css" rel="stylesheet" />
		<link href="\bootstrap\3.03\css\bootstrap-theme.css" rel="stylesheet" />
		<link href="\js\select2\select2-3.4.8\select2-bootstrap.css" rel="stylesheet" />
		<link href="\js\select2\select2-3.4.8\select2.css" rel="stylesheet" />
		<link href="\js\jquery\DataTables-1.10.9\media\css\dataTables.bootstrap.css" rel="stylesheet" />
		<link href="\js\jquery\DataTables-1.10.9\media\css\jquery.dataTables.css" rel="stylesheet" />
		<link href="\js\jquery\jquery-ui-1.11.4\jquery-ui-1.11.4\jquery-ui.css" rel="stylesheet" type="text/css" >

		<script src="\js\jquery\jquery-1.9.1.min.js"></script>
		<script src="\bootstrap\3.03\js\bootstrap.min.js"></script>
		<script src="\js\select2\select2-3.4.8\select2.js"></script>
		<script src="\js\jquery\DataTables-1.10.9\media\js\jquery.dataTables.js"></script>
		<script src="\js\jquery\jquery-ui-1.11.4\jquery-ui-1.11.4\jquery-ui.min.js"></script>

		<style>
			body{
				padding: 20px;
			}
			#avec_livraison, #sans_livraison{
				margin-top: 50px;
				display: none;
			}
			.ui-datepicker {
				background: rgb(60, 133, 196);
				border: 1px solid #555;
				color: #EEE;
			}
			.ui-corner-all {
			 	background: rgb(60, 133, 196);
			 	border: none;
			}
		</style>
</head>

<!--- Rempli le dropdown concessionnaire --->
<cfquery name="QgetDealer" datasource="CarproDB1">
	SELECT *
	FROM DEALERS
	ORDER BY DEALER_NAME
</cfquery>

<cfoutput>
<body>
	<cfinclude template="menu.cfm">

	<form method="post" name="frm_livraison" id="frm_livraison">
		<!--- Concessionnaire --->
		<div class="row col-md-12" id="concessionaireID">
			<div class="col-md-4">
				<div class="btn-group">
					<select name="cco" id="cco" class="form-control select2-select" onchange="ajax_livraison();" style="width:500px">
						<option value="">S&eacute;lectionner un concessionnaire...</option>
						<cfloop query="QgetDealer">
							<option value="#DEALER_CODE#">#trim(DEALER_NAME)# (#trim(STREET)#)</option>
						</cfloop>
					</select>
				</div>
			</div>
			<div align="right"><a href="stats.cfm" class="btn btn-default">Retour &agrave; l'acceuil</a></div>
		</div>

		<div class="col-md-12" id="sans_livraison">
			<div class="panel panel-primary">
				<div class="panel-heading"><strong>PO sans livraison</strong></div>
				<div class="panel-body" id="body_sans_liv">
					<!--- tableau sans livraion par concessionnaire --->
					<table class="table table-striped table-bordered" cellspacing="0" width="100%" id="tblSansLivraison">
						<thead>
							<tr>
								<th align="center">Livraison <input type="checkbox" name="chkSansLivraison" id="chkSansLivraison"></th>
								<th>Num&eacute;ro de PO</th>
								<th>Date de livraison</th>
								<th>Unit&eacute;</th>
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
							<!--- Ajax --->
						</tbody>
					</table>
				</div>
				<div class="panel-footer">
					<!--- Bouton créer une livraison --->
					<div class="row">
						<div class="col-md-12" align="right">
							<b style="color:red; font-size:18px;">Veuillez s&eacute;lectionner une date de livraison pour les unit&eacute;s s&eacute;lectionner afin de continuer s'il vous pla&icirc;t. &nbsp;</b>
							<input type="text" size="7" name="date_livraison" id="date_livraison" required="true"> &nbsp;

							<input type="button" value="Cr&eacute;er Livraison" name="btnCreerLivraison" id="btnCreerLivraison" class="btn btn-default" disabled="disabled">
						</div>
					</div>
				</div>
			</div>

			<div class="panel panel-primary" id="avec_livraison">
				<div class="panel-heading"><strong>PO avec livraison</strong></div>
				<div class="panel-body" id="body_avec_liv">
					<!--- tableau avec livraion de tout les concessionnaires --->
					<div style="display:none;" id="hidden_div"></div>
				</div>
			</div>
		</div>
	</form>
</body>
</cfoutput>

<script type="text/javascript">
	$(document).ready(function() {
		$('#cco').select2();

		$('#tblSansLivraison').DataTable({
			"paging": true,
			"ordering": false,
			"info": false
		});

		$('#tblAvecLivraison').DataTable({
			"paging": true,
			"ordering": false,
			"info": false
		});

		var enableDisableSubmitBtn = function(){
			var startVal = $('#date_livraison').val().trim();
			var disableBtn =  startVal.length == 0;
			
			$('#btnCreerLivraison').attr('disabled',disableBtn);
		}

		$('#date_livraison').datepicker({
			dateFormat: 'mm/dd/yy', onSelect: function(selected) {
			
			$("#date_livraison").datepicker("option","09-04-2015", selected);
				enableDisableSubmitBtn();
			}
		});
	});

	// On rafraîchit les tableau des livraisons (avec et sans)
	function ajax_livraison(){
		var cco = document.getElementById('cco').value;
		var chkId = '';

		$('#body_sans_liv').load('sansLivraison.cfm', {cco: cco}, function() {
			$('#sans_livraison').show();

			$(function () {
				$('#btnCreerLivraison').click(function () { 
					var date_livraison = document.getElementById('date_livraison').value;
					
					if ($('.chkNumber:checked').length) {
						$('.chkNumber:checked').each(function () {
							chkId += $(this).val() + ",";
						});

						chkId = chkId.slice(0, -1);

						$.post('creerLivraison.cfm', {po_id: chkId, date_livraison: date_livraison}, function() {
				      	$('#body_avec_liv').load('avecLivraison.cfm', {cco: cco, po_id: chkId}, function() {
				      		console.log('success');
				      	});
				      	
				      	$('#body_sans_liv').load('sansLivraison.cfm', {cco: cco}, function() {
								console.log('success');
							});
				      });
					} else {
						alert('Veuillez selectionner une valeur.');
					}
				    console.log(cco);
				});

				$('#chkSansLivraison').click(function () {
					$('.chkNumber').prop('checked', $(this).is(':checked'));
				});

				$('.chkNumber').click(function () {
					if ($('.chkNumber:checked').length == $('.chkNumber').length) {
						$('#chkSansLivraison').prop('checked', true);
					}
					else {
						$('#chkSansLivraison').prop('checked', false);
					}
				});
			});

		});

		$('#body_avec_liv').load('avecLivraison.cfm', {cco: cco, po_id: chkId}, function(){
			$('#avec_livraison').show();
		});
	}
</script>
</html>
