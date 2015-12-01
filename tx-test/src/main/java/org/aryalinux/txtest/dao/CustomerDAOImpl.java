package org.aryalinux.txtest.dao;

import java.util.List;

import org.aryalinux.txtest.model.Customer;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CustomerDAOImpl {
	@Autowired
	private SessionFactory sessionFactory;

	@SuppressWarnings("unchecked")
	public Customer getCustomer(Integer customerId) {
		Session session = sessionFactory.openSession();
		Criteria criteria = session.createCriteria(Customer.class);
		criteria.add(Restrictions.eq("id", customerId));
		List<Customer> customers = (List<Customer>) criteria.list();
		session.close();
		if (customers != null && customers.size() > 0) {
			return customers.get(0);
		} else {
			return null;
		}
	}
	
	public Integer newCustomer(Customer customer) {
		Session session = sessionFactory.openSession();
		Integer id = (Integer) session.save(customer);
		session.close();
		return id;
	}
}
