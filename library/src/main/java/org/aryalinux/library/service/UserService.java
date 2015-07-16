package org.aryalinux.library.service;

import org.aryalinux.library.service.dto.UserDTO;

public interface UserService {
	boolean authenticate(String emailAddress, String password);

	void changePassword(String emailAddress, String newPasword);

	UserDTO getDetails(String emailAddress);
}
