package ecg_extra;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import net.sourceforge.jFuzzyLogic.FIS;
import net.sourceforge.jFuzzyLogic.FunctionBlock;
import net.sourceforge.jFuzzyLogic.plot.JFuzzyChart;
import net.sourceforge.jFuzzyLogic.rule.Variable;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.kie.api.KieServices;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.rule.QueryResults;
import org.kie.api.runtime.rule.QueryResultsRow;

public class MainClass {
	private static String fileNameFcl = "fcl/ecg.fcl";
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
	
	private static void analisis (String filepath, KieSession kSession, FIS fis){
		
		Variable taq = null;
		Variable brad = null;
		Variable hip = null;
		Variable hipop = null;
		Variable infAg = null;
		
		int cicloInfarto = 0;
		int cicloHipocalcemia = 0;
		int cicloHipopotasemia = 0;

		double bradicardia = -1;
		double taquicardia = -1;
		double hipocalcemia = -1;
		double hipopotasemia = -1;
		double infartoAgudoMiocardio = -1;
		
		System.out.println("\n--------------------------------- En el fichero: " + filepath + "-----------------------------------------\n");
		
		FunctionBlock functionBlock = fis.getFunctionBlock("bradicardia_taquicardia");
		
		QueryResults results = 
				kSession.getQueryResults("ObtenerPulsaciones");
		
		for( QueryResultsRow row : results) {
			RitmoCardiaco rc = ( RitmoCardiaco ) row.get("$result");
			functionBlock.setVariable("ritmo", rc.getPulsaciones());
			functionBlock.evaluate();
			taquicardia = functionBlock.getVariable("taquicardia").defuzzify();
			taq = functionBlock.getVariable("taquicardia");
			if (taquicardia > 0.5) {
				System.out.println("Se ha detectado una certeza de: " + taquicardia + " para la enfermedad Taquicardia.");
				System.out.println("Se concluye que: Se padece Taquicardia");
		        JFuzzyChart.get().chart(taq, taq.getDefuzzifier(), true);
		        break;
			}
			
			bradicardia = functionBlock.getVariable("bradicardia").defuzzify();
			brad = functionBlock.getVariable("bradicardia");
			if (bradicardia > 0.5) {
				System.out.println("Se ha detectado una certeza de: " + bradicardia + " para la enfermedad Bradicardia.");
				System.out.println("Se concluye que: Se padece Bradicardia");
				JFuzzyChart.get().chart(brad, brad.getDefuzzifier(), true);
				break;
			}
		}
				
		functionBlock = fis.getFunctionBlock("hipocalcemia");
		results = kSession.getQueryResults("ObtenerDuracionIQT");
		
		for( QueryResultsRow row : results) {
			IntervaloQT iQT = ( IntervaloQT ) row.get("$result");
			functionBlock.setVariable("duracionQT", iQT.getDuracion());
			functionBlock.evaluate();
			hipocalcemia = functionBlock.getVariable("hipocalcemia").defuzzify();
			hip = functionBlock.getVariable("hipocalcemia");
			if (hipocalcemia > 0.5) {
				cicloHipocalcemia = iQT.getCiclo();
				System.out.println("Se ha detectado una certeza de: " + hipocalcemia + " para la enfermedad Hipocalcemia.");
				System.out.println("Se concluye que: Se padece Hipocalcemia, con evidencia en el ciclo " + cicloHipocalcemia + "\n");
				JFuzzyChart.get().chart(hip, hip.getDefuzzifier(), true);
				break;
			}
		}
		
		
		functionBlock = fis.getFunctionBlock("hipopotasemia");
		results = kSession.getQueryResults("ObtenerAlturaOndaT");
		
		for( QueryResultsRow row : results) {
			OndaT ondaT = ( OndaT ) row.get("$result");
			functionBlock.setVariable("alturaT", ondaT.getAltura());
			functionBlock.evaluate();
			hipopotasemia = functionBlock.getVariable("hipopotasemia").defuzzify();
			hipop = functionBlock.getVariable("hipopotasemia");
			if (hipopotasemia > 0.5) {
				cicloHipopotasemia = ondaT.getCiclo();
				System.out.println("Se ha detectado una certeza de: " + hipopotasemia + " para la enfermedad Hipopotasemia.");
				System.out.println("Se concluye que: Se padece Hipopotasemia, con evidencia en el ciclo " + cicloHipopotasemia + "\n");
				JFuzzyChart.get().chart(hipop, hipop.getDefuzzifier(), true);
				break;
			}
		}
				
		functionBlock = fis.getFunctionBlock("infartoAgudoMiocardio");
		results = kSession.getQueryResults("ObtenerAlturaOndaT");
		
		for( QueryResultsRow row : results) {
			OndaT ondaT = ( OndaT ) row.get("$result");
			functionBlock.setVariable("alturaT", ondaT.getAltura());
			functionBlock.evaluate();
			infartoAgudoMiocardio = functionBlock.getVariable("infartoAgudoMiocardio").defuzzify();
			infAg = functionBlock.getVariable("infartoAgudoMiocardio");
			if (infartoAgudoMiocardio > 0.5) {
				cicloInfarto = ondaT.getCiclo();
				System.out.println("Se ha detectado una certeza de: " + infartoAgudoMiocardio + " para la enfermedad Infarto agudo de miocardio.");
				System.out.println("Se concluye que: Se padece infarto agudo de miocardio, con evidencia en el ciclo " + cicloInfarto + "\n");
		        JFuzzyChart.get().chart(infAg, infAg.getDefuzzifier(), true);
		        break;
			}
		}
		
		if (taquicardia < 0.5 && bradicardia < 0.5 && hipopotasemia < 0.5 && hipocalcemia < 0.5 && infartoAgudoMiocardio < 0.5) {
			System.out.println("El paciente se encuentra de locos\n");
			JFuzzyChart.get().chart(taq, taq.getDefuzzifier(), true);
			JFuzzyChart.get().chart(brad, brad.getDefuzzifier(), true);
			JFuzzyChart.get().chart(hip, hip.getDefuzzifier(), true);
			JFuzzyChart.get().chart(hipop, hipop.getDefuzzifier(), true);
			JFuzzyChart.get().chart(infAg, infAg.getDefuzzifier(), true);
		}
			
	}	

	public static void main(String[] args) {
		
		String ficheros[] = new String[]{"./muestras/taquicardia.ecg", "./muestras/bradicardia.ecg",
				"./muestras/hipocalcemia.ecg","./muestras/hipocalcemia+iam.ecg",
				"./muestras/hipocalcemia+hipopotasemia.ecg", "./muestras/iam.ecg",
				"./muestras/normal.ecg"};

		// Para el uso de FuzzyLogic
		FIS fis = null;
        try {
            fis = FIS.load(fileNameFcl, true);
        } catch (Exception e) {
            System.err.println("ERROR: File '" + fileNameFcl + "' (check format)");
        }
        // Error while loading?
        if (fis == null) {
            System.err.println("ERROR: Missing file: '" + fileNameFcl + "' (check path)");
            return;
        }
        
        FunctionBlock functionBlock = fis.getFunctionBlock("bradicardia_taquicardia");
        JFuzzyChart.get().chart(functionBlock);
        
        functionBlock = fis.getFunctionBlock("hipocalcemia");
        JFuzzyChart.get().chart(functionBlock);
        
        functionBlock = fis.getFunctionBlock("hipopotasemia");
        JFuzzyChart.get().chart(functionBlock);
        
        functionBlock =  fis.getFunctionBlock("infartoAgudoMiocardio");
        JFuzzyChart.get().chart(functionBlock);

        //Comenzamos construyendo los patrones
		Pattern patPulsaciones = Pattern.compile(pulsaciones);
		Pattern patOnda = Pattern.compile(onda);
		
        for (String fileName : ficheros) {
        	
        	KieServices ks= KieServices.Factory.get();
    		KieContainer kc= ks.getKieClasspathContainer();
    		KieSession kSession= kc.newKieSession("ksession-rules-ecg");
    		
        	//PARSEO
    		try {
    			String file = fileToString(fileName);
    			
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
    		} catch (IOException e) {
    			e.printStackTrace();
    		}
    		
    		//Disparamos las reglas
    		kSession.getAgenda().getAgendaGroup("Inicializacion").setFocus();
    		kSession.fireAllRules();
    		
            //Ejecución del sistema Fuzzy 
            analisis(fileName, kSession, fis);
		}
        
	}
}