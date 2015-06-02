package Main;
import java.io.FileWriter;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.wb.swt.SWTResourceManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;


public class Main {

	protected Shell shlWadjet;
	private Text txtConfianza;
	private Text txtMeses;
	private Text txtAnoIn;
	private Text txtMesIn;

	/**
	 * Launch the application.
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			//Desktop.getDesktop().open(new File("/Applications/R.app")); not needed
			Runtime.getRuntime().exec("Rscript ./RFiles/Wadjet/Scripts/Integration/Analisis.R"); // Terminal modify permissions of file: chmod u+x pathfile  
			Main window = new Main();
			window.open();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Open the window.
	 */
	public void open() {
		Display display = Display.getDefault();
		createContents();
		shlWadjet.open();
		shlWadjet.layout();
		while (!shlWadjet.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
	}

	/**
	 * Create contents of the window.
	 */
	protected void createContents() {
		shlWadjet = new Shell();
		shlWadjet.setMinimumSize(new Point(800, 600));
		shlWadjet.setBackground(SWTResourceManager.getColor(60, 179, 113));
		shlWadjet.setSize(450, 300);
		shlWadjet.setText("Wadjet-v. 1.0");
		
		Label lblSnake = new Label(shlWadjet, SWT.NONE);
		lblSnake.setImage(SWTResourceManager.getImage(Main.class, "/Assets/Greensnake.png"));
		lblSnake.setBounds(128, 73, 221, 150);
		
		Label lblTitle = new Label(shlWadjet, SWT.NONE);
		lblTitle.setText("WADJET");
		lblTitle.setFont(SWTResourceManager.getFont("Bradley Hand", 33, SWT.BOLD));
		lblTitle.setBounds(173, 219, 126, 47);
		
		Label lblDepto = new Label(shlWadjet, SWT.NONE);
		lblDepto.setText("Departamento:");
		lblDepto.setFont(SWTResourceManager.getFont("Lucida Grande", 13, SWT.BOLD));
		lblDepto.setBounds(116, 276, 103, 17);
		
		final Combo menuDepto = new Combo(shlWadjet, SWT.NONE);
		menuDepto.setFont(SWTResourceManager.getFont("Lucida Sans", 11, SWT.NORMAL));
		menuDepto.setItems(new String[] {"TODOS", "AMAZONAS", "ANTIOQUIA", "ARAUCA", "ATLANTICO", "BOGOTA", "BOLIVAR", "BOYACA", "CALDAS", "CAQUETA", "CASANARE", "CAUCA", "CESAR", "CHOCO", "CORDOBA", "CUNDINAMARCA", "GUAINIA", "GUAJIRA", "GUAVIARE", "HUILA", "MAGDALENA", "META", "NARI\u00D1O", "NORTE SANTANDER", "PUTUMAYO", "QUINDIO", "RISARALDA", "SANTANDER", "SUCRE", "TOLIMA", "VALLE", "VAUPES", "VICHADA"});
		menuDepto.setBounds(254, 272, 115, 34);
		menuDepto.setText("Elegir...");
		
		Label lblConfianza = new Label(shlWadjet, SWT.NONE);
		lblConfianza.setText("Confianza:");
		lblConfianza.setFont(SWTResourceManager.getFont("Lucida Grande", 13, SWT.BOLD));
		lblConfianza.setBounds(116, 313, 74, 17);
		
		txtConfianza = new Text(shlWadjet, SWT.BORDER);
		txtConfianza.setFont(SWTResourceManager.getFont("Lucida Sans", 11, SWT.NORMAL));
		txtConfianza.setText("0.9");
		txtConfianza.setBounds(305, 310, 64, 19);
		
		Label lblExplic = new Label(shlWadjet, SWT.NONE);
		lblExplic.setText("(probabilidad de cubrir todos los casos)");
		lblExplic.setFont(SWTResourceManager.getFont("Lucida Grande", 9, SWT.NORMAL));
		lblExplic.setBounds(116, 330, 209, 14);
		
		Label lblMeses = new Label(shlWadjet, SWT.NONE);
		lblMeses.setText("Meses predicci\u00F3n:");
		lblMeses.setFont(SWTResourceManager.getFont("Lucida Grande", 13, SWT.BOLD));
		lblMeses.setBounds(116, 428, 120, 17);
		
		txtMeses = new Text(shlWadjet, SWT.BORDER);
		txtMeses.setFont(SWTResourceManager.getFont("Lucida Sans", 11, SWT.NORMAL));
		txtMeses.setText("12");
		txtMeses.setBounds(305, 425, 64, 19);
		
		Button btnCalcular = new Button(shlWadjet, SWT.NONE);
		btnCalcular.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				//Call R
				int index = menuDepto.getSelectionIndex();
				String depto;
				double conf;
				int meses;
				int mesIn;
				int anyoIn;
				
				if (index != -1) {
					depto = menuDepto.getItems()[index];
					if (depto.contains("NARI")) {
						depto = "NARINYO";
					}
					
					try {
						conf = Double.parseDouble(txtConfianza.getText());
						meses = Integer.parseInt(txtMeses.getText());
						mesIn = Integer.parseInt(txtMesIn.getText());
						anyoIn = Integer.parseInt(txtAnoIn.getText());
						if (conf < 1 && conf > 0 && meses <= 12 && meses >= 1 && mesIn <= 12 && mesIn >= 1 && anyoIn <= 2015 && anyoIn >= 2010) {
							if (depto.equals("TODOS")) {
								System.out.print("TODOS");
								MessageBox warn = new MessageBox(shlWadjet, SWT.ICON_QUESTION | SWT.OK | SWT.CANCEL);
								warn.setText("¿Calcular todo el país?");
								warn.setMessage("Predecir los accidentes de todo el país puede tardar varios minutos. ¿Desea continuar?");
								int resp = warn.open();
								if (resp == SWT.OK) {
									//R exit point forecastAll
									MessageBox dialog = new MessageBox(shlWadjet, SWT.ICON_QUESTION | SWT.OK);
									dialog.setText("Calculando");
									dialog.setMessage("...Paciencia por favor...");
									dialog.open();
									//Runtime.getRuntime().exec("/"); 
								}
							}
							else {
								//R exit point forecast(depto)
								try {
									FileWriter param = new FileWriter("./RFiles/Wadjet/Data/Param/param.csv");
									param.append(depto);
									param.append(",");
									param.append(Integer.toString(anyoIn));
									param.append(",");
									param.append(Integer.toString(mesIn));
									param.append(",");
									param.append(Integer.toString(meses));
									param.append(",");
									param.append(Double.toString(conf));
									param.append("\n");
									param.flush();
									param.close();
								} catch(Exception ex) {
									ex.printStackTrace();
								}
								Runtime.getRuntime().exec("Rscript ./RFiles/Wadjet/Scripts/Integration/ForecastDep.R"); //TODO: 2015 data. Graphs zoomed on prediction.
								Thread.sleep(4000);
								Runtime.getRuntime().exec("open ./RFiles/Wadjet/Data/Output/Season.png");
								Thread.sleep(4000);
								Runtime.getRuntime().exec("open ./RFiles/Wadjet/Data/Output/Arimax.png");
								Runtime.getRuntime().exec("open ./RFiles/Wadjet/Data/Output/PrediccionDep.csv");
							}
							
							
						}
						else {
							throw new Exception();
						}
					}
					catch (Exception error) {
						MessageBox err = new MessageBox(shlWadjet, SWT.ICON_QUESTION | SWT.OK);
						err.setText("Ups...");
						err.setMessage("Recuerda... \n\nEl intervalo de confianza debe ser un número entre 0 y 1. \n\nEl año de inicio de predicción debe estar entre 2010 y 2015. \n\nEl mes de inicio debe estar entre 1 y 12. \n\nEl número de meses predecidos debe estar entre 1 y 12.");
						err.open();
						error.printStackTrace();
					}
					
				
				}
				
			
			}
		});
		btnCalcular.setText("Calcular");
		btnCalcular.setFont(SWTResourceManager.getFont(".Helvetica Neue DeskInterface", 11, SWT.BOLD));
		btnCalcular.setBounds(173, 466, 122, 28);
		
		Button btnAcerca = new Button(shlWadjet, SWT.NONE);
		btnAcerca.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				MessageBox dialog = new MessageBox(shlWadjet, SWT.ICON_QUESTION | SWT.OK);
				dialog.setText("Acerca de Wadjet");
				dialog.setMessage("Wadjet es un software que estima los accidentes ofídicos en cada departamento de Colombia durante un intervalo a futuro de tiempo y las dosis de suero antiofídico necesarias para cubrirlos. \n \nWadjet es desarrollado por Sara Nieto Díaz, Luisa Vargas Daza, Camilo Pérez Martínez, Lucía Pérez Herrera y Pablo Cárdenas Ramírez, estudiantes del departamento de Ingeniería Biomédica de la Universidad de los Andes. \n \nWadjet también es la diosa egipcia de las serpientes. Imagen de serpiente: Creative Commons, Clipart Panda, http://www.clipartpanda.com/clipart_images/snake-clip-art-free-download-5393025\n \nLicencia MIT.");
				dialog.open();
			}
		});
		btnAcerca.setFont(SWTResourceManager.getFont(".Helvetica Neue DeskInterface", 10, SWT.NORMAL));
		btnAcerca.setText("Acerca de");
		btnAcerca.setBounds(589, 471, 95, 28);
		
		Label lblMap = new Label(shlWadjet, SWT.NONE);
		lblMap.setText("Mapa");
		lblMap.setImage(SWTResourceManager.getImage(Main.class, "/Assets/mapita.png"));
		lblMap.setBounds(440, 111, 272, 314);
		
		Button btnayuda = new Button(shlWadjet, SWT.NONE);
		btnayuda.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				MessageBox dialog = new MessageBox(shlWadjet, SWT.ICON_QUESTION | SWT.OK);
				dialog.setText("Acerca de Wadjet");
				dialog.setMessage("WADJET es un modelo computacional que predice la incidencia de accidentes antiofídicos en Colombia. En primer lugar, para buscar  la incidencia de accidentes por departamento se debe seleccionar el departamento buscado y se deben ingresar los datos de confianza, fecha de inicio y cantidad de meses de predicción. A continuación, aparecerán ventanas con gráficas de casos históricos y predicción de accidentes antiofídicos con dos algoritmos de predicción diferentes. Así mismo, se mostrará en la pantalla un archivo que presenta la cantidad de dosis de suero requeridas y el presupuesto necesario para adquirirlas. A partir de estos datos, se realizará la lista con la cantidad de suero antiofídico requerido para realizar el pedido.");
				dialog.open(); 
			}
		});
		btnayuda.setText("\u00BFAyuda?");
		btnayuda.setFont(SWTResourceManager.getFont(".Helvetica Neue DeskInterface", 10, SWT.NORMAL));
		btnayuda.setBounds(475, 471, 95, 28);
		
		Label lblAoInicio = new Label(shlWadjet, SWT.NONE);
		lblAoInicio.setText("A\u00F1o inicio de predicci\u00F3n:");
		lblAoInicio.setFont(SWTResourceManager.getFont("Lucida Grande", 13, SWT.BOLD));
		lblAoInicio.setBounds(116, 357, 166, 17);
		
		txtAnoIn = new Text(shlWadjet, SWT.BORDER);
		txtAnoIn.setText("2015");
		txtAnoIn.setFont(SWTResourceManager.getFont("Lucida Sans", 11, SWT.NORMAL));
		txtAnoIn.setBounds(305, 354, 64, 19);
		
		Label lblMesInicio = new Label(shlWadjet, SWT.NONE);
		lblMesInicio.setText("Mes inicio de predicci\u00F3n:");
		lblMesInicio.setFont(SWTResourceManager.getFont("Lucida Grande", 13, SWT.BOLD));
		lblMesInicio.setBounds(116, 392, 167, 17);
		
		txtMesIn = new Text(shlWadjet, SWT.BORDER);
		txtMesIn.setText("1");
		txtMesIn.setFont(SWTResourceManager.getFont("Lucida Sans", 11, SWT.NORMAL));
		txtMesIn.setBounds(305, 389, 64, 19);

	}

}
