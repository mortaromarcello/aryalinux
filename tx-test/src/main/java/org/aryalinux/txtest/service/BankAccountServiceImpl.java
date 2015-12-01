package org.aryalinux.txtest.service;

import org.aryalinux.txtest.dao.BankAccountDAOImpl;
import org.aryalinux.txtest.model.BankAccount;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Component
public class BankAccountServiceImpl {
	@Autowired
	private BankAccountDAOImpl bankAccountDAOImpl;

	public Integer openAccount(BankAccount account) {
		return bankAccountDAOImpl.createAccount(account);
	}

	public BankAccount getAccountDetails(Integer accountNumber) {
		return bankAccountDAOImpl.getAccount(accountNumber);
	}

	public Integer doMoneyTranser(Integer fromAccount, Integer toAccount, Double amount, String description) {
		return bankAccountDAOImpl.moneyTransfer(fromAccount, toAccount, amount, description);
	}
}
