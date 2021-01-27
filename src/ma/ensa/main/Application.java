package ma.ensa.main;

import ma.ensa.entities.Client;
import ma.ensa.entities.Compte;

public class Application {

	public static void main(String[] args) {
		Compte monCompte = new Compte(2000);
		Client monClient = new Client("Yassine", monCompte);
		
		monClient.retirer(500); // 1500
		monClient.verser(400); // 1900

	}

}
