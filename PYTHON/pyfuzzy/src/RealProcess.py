# -*- coding: iso-8859-1 -*-

from simulation import Process


class RealProcess(Process.Process):
    """Interface to the real (hardware) process."""

    def getStateValues(self,dict):
        """ask hardware for values"""
        pass

    def setControlValues(self,dict):
        """send values to hardware"""
        pass

    def getDefaultControlValues(self):
        pass
