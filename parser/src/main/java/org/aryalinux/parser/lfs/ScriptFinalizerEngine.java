package org.aryalinux.parser.lfs;

import java.util.ArrayList;
import java.util.List;

import org.aryalinux.parser.commons.lfs.Finalizer;
import org.aryalinux.parser.finalizer.lfs.InputsReplacementFinalizer;

public class ScriptFinalizerEngine {
	private static ScriptFinalizerEngine instance;
	private List<Finalizer> finalizers;

	private ScriptFinalizerEngine() throws Exception {
		finalizers = new ArrayList<Finalizer>();
		finalizers.add(new InputsReplacementFinalizer());
	}

	public static ScriptFinalizerEngine instance() throws Exception {
		if (instance == null) {
			instance = new ScriptFinalizerEngine();
		}
		return instance;
	}

	public void finalizeScripts() throws Exception {
		for (Finalizer finalizer : finalizers) {
			finalizer.finalizeScripts();
		}
	}
}
