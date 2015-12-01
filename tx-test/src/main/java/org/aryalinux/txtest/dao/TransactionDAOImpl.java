package org.aryalinux.txtest.dao;

import java.util.List;

import org.aryalinux.txtest.model.AccountTransaction;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;

public class TransactionDAOImpl {
	@Autowired
	private SessionFactory sessionFactory;

	@SuppressWarnings("unchecked")
	public List<AccountTransaction> getTransactions(Integer accountNumber) {
		Session session = sessionFactory.openSession();
		String sql = "from AccountTransaction tran join fetch tran.bankAccount where tran.bankAccount.id=:acctNum";
		Query query = session.createQuery(sql);
		query.setParameter("acctNum", accountNumber);
		List<AccountTransaction> transactions = (List<AccountTransaction>) query.list();
		return transactions;
	}
}
