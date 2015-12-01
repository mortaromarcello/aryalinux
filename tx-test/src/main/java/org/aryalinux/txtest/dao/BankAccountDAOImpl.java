package org.aryalinux.txtest.dao;

import java.util.Date;
import java.util.List;

import org.aryalinux.txtest.model.AccountTransaction;
import org.aryalinux.txtest.model.BankAccount;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Component
public class BankAccountDAOImpl {
	@Autowired
	private SessionFactory sessionFactory;

	public Integer createAccount(BankAccount account) {
		Session session = sessionFactory.openSession();
		Integer accountNumber = (Integer) session.save(account);
		session.close();
		return accountNumber;
	}

	@SuppressWarnings("unchecked")
	public BankAccount getAccount(Integer accountNumber) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(BankAccount.class);
		criteria.add(Restrictions.eq("id", accountNumber));
		List<BankAccount> accounts = (List<BankAccount>) criteria.list();
		session.close();
		if (accounts != null && accounts.size() > 0) {
			return accounts.get(0);
		} else {
			return null;
		}
	}

	@Transactional(rollbackFor = MyException.class, readOnly = false, transactionManager = "transactionManager", propagation = Propagation.REQUIRES_NEW)
	public Integer moneyTransfer(Integer fromAccount, Integer toAccount, Double amount, String description) {
		Session session = sessionFactory.openSession();
		BankAccount from = getAccount(fromAccount);
		BankAccount to = getAccount(toAccount);
		AccountTransaction debit = new AccountTransaction();
		AccountTransaction credit = new AccountTransaction();

		debit.setBankAccount(from);
		debit.setAmount(amount * -1);
		debit.setDescription(description);
		debit.setCreatedDate(new Date());

		Integer id = (Integer) session.save(debit);

		if (true) {
			throw new MyException();
		}

		credit.setBankAccount(to);
		credit.setAmount(amount);
		credit.setDescription(description);
		credit.setCreatedDate(new Date());

		session.save(credit);

		from.setBalance(from.getBalance() - amount);
		to.setBalance(to.getBalance() + amount);

		session.saveOrUpdate(from);
		session.saveOrUpdate(to);

		return id;
	}
}
