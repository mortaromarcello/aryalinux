package org.aryalinux.txtest.service;

import org.aryalinux.txtest.dao.CustomerDAOImpl;
import org.aryalinux.txtest.model.Customer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CustomerServiceImpl {
	@Autowired
	private CustomerDAOImpl customerDAOImpl;

	public Integer saveCustomer(Customer customer) {
		return customerDAOImpl.newCustomer(customer);
	}

	public Customer getCustomer(Integer customerId) {
		return customerDAOImpl.getCustomer(customerId);
	}
}
