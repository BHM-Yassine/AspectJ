package ma.ensa.aspect;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;

import ma.ensa.entities.Client;
import ma.ensa.entities.Compte;

import java.util.Date;

import org.apache.log4j.Logger;

@Aspect
public class JournalisationAspect {

	static Logger logger = Logger.getLogger(JournalisationAspect.class);

	// * ma.ensa.entities.Compte.debiter(..)
	@Pointcut("execution(public void *..Client.retirer(*))")
	public void logRetirer() {
	};

	@Pointcut("execution(public void *..Client.verser(*))")
	public void logVerser() {
	};

	@Before("logRetirer()")
	public void beforeRetirer() {
		logger.info("Avant le d�bit: " + System.currentTimeMillis());
	}

	@Before("logVerser()")
	public void beforeApprovisionner() {
		logger.info("Avant le credit: " + System.currentTimeMillis());
	}

	@Around("logRetirer()")
	public void aroundRetirer(ProceedingJoinPoint joinpoint) throws Throwable {
		System.out.println("=> Entr�e dans la m�thode D�biter");
		Object[] args = joinpoint.getArgs();

		Double mt = (Double) args[0];

		Client client = (Client) joinpoint.getTarget();

		if (client.getCp().getSolde() > mt) {
			Long d1 = System.currentTimeMillis();
			joinpoint.proceed();
			Long d2 = System.currentTimeMillis();
			Long diff = d2-d1;
			
			logger.info("le compte a �t� d�biter par: " + client.getNom() + ", et le nouveau solde est " + client.getCp().getSolde());
			logger.info("La dur�e d'�xecution de la m�thode est: " + diff);
		} else {
			logger.info("Solde insuffisant");
		}

		System.out.println("<= Sortie dans la m�thode D�biter");
	}

	@Around("logVerser()")
	public void aroundApprovisionner(ProceedingJoinPoint joinpoint) throws Throwable {
		System.out.println("=> Entr�e dans la m�thode Approvisionner");
		
		Client client = (Client) joinpoint.getTarget();
		
		Long d1 = System.currentTimeMillis();
		joinpoint.proceed();
		Long d2 = System.currentTimeMillis();
		Long diff = d2-d1;
		
		logger.info("Le virement effectuer par: " + client.getNom() + ", et le nouveau solde est " + client.getCp().getSolde());
		logger.info("La dur�e d'�xecution de la m�thode est: " + diff);
		
		System.out.println("<= Sortie dans la m�thode Approvisionner");
	}

	@After("logRetirer()")
	public void afterRetirer() {
		logger.info("Apr�s le d�bit: " + System.currentTimeMillis());
	}

	@After("logVerser()")
	public void afterApprovisioner() {
		logger.info("Apr�s le credit: " + System.currentTimeMillis());
	}

}
