package ecg;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Scanner;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.kie.api.KieServices;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;

public class MainClass {
	private static String pulsaciones = "# Heart_Rate : ([0-9]*) pul/min";
	private static String onda = "([PQRST])\\(([0-9]+),([0-9]+),(-?[0-9]+.[0-9]+)\\)";
	
	private static String fileToString(String path) throws IOException {
		BufferedReader bReader = new BufferedReader(new FileReader(path));
	    StringBuilder cadena = new StringBuilder();
	    String line = null;
	    
	    while ((line = bReader.readLine()) != null) {
	    	cadena.append(line);
	    }
	    bReader.close();
	    return cadena.toString();
    }

	public static void main(String[] args) {
		
		KieServices ks= KieServices.Factory.get();
		KieContainer kc= ks.getKieClasspathContainer();
		KieSession kSession= kc.newKieSession("ksession-rules-ecg");
		
		//Lectura del fichero que contiene el electrocardiograma
		System.out.println("Introduce ruta del fichero inicial: ");
		Scanner scanIn = new Scanner(System.in);
        String fileName = scanIn.nextLine();
        scanIn.close();
        
        //PARSEO
		try {
			String file = fileToString(fileName);
			
	        //Comenzamos construyendo los patrones
			Pattern patPulsaciones = Pattern.compile(pulsaciones);
			Pattern patOnda = Pattern.compile(onda);
			
			//Construimos los matchers
	        Matcher matPulsaciones = patPulsaciones.matcher(file);
	        Matcher matOnda = patOnda.matcher(file);
	        
	        matPulsaciones.find();
	        RitmoCardiaco rC = new RitmoCardiaco(Integer.valueOf(matPulsaciones.group(1)));
	        kSession.insert(rC);
	        
	        //Definición de las variables necesarias para el parseo del 
	        //fichero de ECG
	        int ciclo = 0;
	        int finOnda;
	        int inicioOnda;
	        double alturaOnda;
	        
	        while(matOnda.find()) {
	        	Onda onda;
	        	inicioOnda = Integer.valueOf(matOnda.group(2));
	        	finOnda = Integer.valueOf(matOnda.group(3));
	        	alturaOnda = Double.valueOf(matOnda.group(4));
	        	switch (matOnda.group(1)) {
				case "P": {
					ciclo++;
					onda = new OndaP(ciclo, inicioOnda, finOnda, alturaOnda);
					break;
				}
				case "Q":{
					onda = new OndaQ(ciclo, inicioOnda, finOnda, alturaOnda);
					break;
				}
				case "R":{
					onda = new OndaR(ciclo, inicioOnda, finOnda, alturaOnda);
					break;			
				}
				case "S":{
					onda = new OndaS(ciclo, inicioOnda, finOnda, alturaOnda);
					break;
				}
				case "T":{
					onda = new OndaT(ciclo, inicioOnda, finOnda, alturaOnda);
					break;				
				}
				default:
					throw new IllegalArgumentException("Unexpected value: " + matOnda.group(1));
				}
	        	kSession.insert(onda);
	        }
		} catch (FileNotFoundException e) {
			System.out.println("Aprende a escribir");
			System.exit(1);
		} catch (IOException e) {
			e.printStackTrace();
			System.exit(2);
		}
		
		
		System.out.println("\n/////////////////////////////////////////////////////////");
		System.out.println("                    Disparar Reglas                        ");
		System.out.println("/////////////////////////////////////////////////////////\n");
		
		
		kSession.getAgenda().getAgendaGroup("Inicializacion").setFocus();
		kSession.fireAllRules();
		
		kSession.getAgenda().getAgendaGroup("DeteccionIndicios").setFocus();
		kSession.fireAllRules();
		
		kSession.getAgenda().getAgendaGroup("DeteccionEnfermedades").setFocus();
		kSession.fireAllRules();
		
		kSession.getAgenda().getAgendaGroup("Impresion").setFocus();
		kSession.fireAllRules();
	}

}