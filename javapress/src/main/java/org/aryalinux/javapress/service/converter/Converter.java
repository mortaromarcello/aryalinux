package org.aryalinux.javapress.service.converter;

import java.util.ArrayList;
import java.util.List;

public abstract class Converter<A, B> {
	public abstract B convert(A ref);

	public abstract A convertBack(B ref);

	public List<B> convert(List<A> list) {
		List<B> converted = new ArrayList<B>();
		for (A ref : list) {
			converted.add(convert(ref));
		}
		return converted;
	}
	public List<A> convertBack(List<B> list) {
		List<A> converted = new ArrayList<A>();
		for (B ref : list) {
			converted.add(convertBack(ref));
		}
		return converted;
	}
}
