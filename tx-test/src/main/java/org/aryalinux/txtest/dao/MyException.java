package org.aryalinux.txtest.dao;

public class MyException extends RuntimeException {
	public static final long serialVersionUID = 134234l;
	
	public MyException() {
		super("My special exception occured...");
	}
}
