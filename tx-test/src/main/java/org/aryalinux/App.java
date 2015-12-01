package org.aryalinux;

import java.util.Date;

import org.aryalinux.txtest.model.BankAccount;
import org.aryalinux.txtest.model.Customer;
import org.aryalinux.txtest.service.BankAccountServiceImpl;
import org.aryalinux.txtest.service.CustomerServiceImpl;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class App {
	public static Customer getDummyCustomer(String name) {
		Customer customer = new Customer();
		customer.setName(name);
		customer.setCreatedBy("system");
		customer.setCreatedDate(new Date());
		return customer;
	}

	public static BankAccount createDummyBankAccount(Customer customer) {
		BankAccount bankAccount = new BankAccount();
		bankAccount.setCreatedBy("system");
		bankAccount.setCustomer(customer);
		bankAccount.setCreatedDate(new Date());
		bankAccount.setBalance(5000.0);
		return bankAccount;
	}

	public static void main(String[] args) {
		ClassPathXmlApplicationContext applicationContext = new ClassPathXmlApplicationContext("beans.xml");
		CustomerServiceImpl customerServiceImpl = applicationContext.getBean(CustomerServiceImpl.class);
		BankAccountServiceImpl accountServiceImpl = applicationContext.getBean(BankAccountServiceImpl.class);

		Integer id1 = customerServiceImpl.saveCustomer(getDummyCustomer("Chandrakant Singh"));
		Integer id2 = customerServiceImpl.saveCustomer(getDummyCustomer("Suryakant Singh"));
		System.out.println("Created customer. Id: " + id1);
		System.out.println("Created customer. Id: " + id2);

		Customer c1 = customerServiceImpl.getCustomer(id1);
		Customer c2 = customerServiceImpl.getCustomer(id2);

		BankAccount account1 = createDummyBankAccount(c1);
		BankAccount account2 = createDummyBankAccount(c2);

		Integer acNo1 = accountServiceImpl.openAccount(account1);
		Integer acNo2 = accountServiceImpl.openAccount(account2);

		accountServiceImpl.doMoneyTranser(acNo1, acNo2, 3000.00, "Sent money home");
		
		applicationContext.close();
	}
}
