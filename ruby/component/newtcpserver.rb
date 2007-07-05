# Created by Satoshi Nakagawa.
# You can redistribute it and/or modify it under the Ruby's license or the GPL2.

class NewTcpServer < OSX::NSObject
  include OSX
  attr_accessor :delegate, :port
  
  def initialize
    @port = 0
    @clients = []
  end
  
  def open
    if @sock
      @sock.close
    else
      @sock = AsyncTcpServer.alloc.init
      @sock.delegate = self
    end
    @sock.port = port
    @active = @sock.open
  end
  
  def close
    return unless @sock
    @sock.close
    @active = false
  end
  
  def active?
    @active
  end
  
  def clients
    return nil unless @sock
    @sock.clients
  end
  
  def close_client(client)
    return unless @sock
    @sock.close_client(client)
  end
  
  def close_all_clients
    return unless @sock
    @sock.close_all_clients
  end


  def tcpServerAccepted(sock)
  end

  def tcpServerClientConnected(c)
    @delegate.tcpserver_on_connect(self, c) if @delegate
  end

  def tcpServerClientDisconnected(c)
    @delegate.tcpserver_on_disconnect(self, c) if @delegate
    close_client(c)
  end

  def tcpServerClientReceived(c)
    @delegate.tcpserver_on_read(self, c) if @delegate
  end

  def tcpServerClientSent(c)
    @delegate.tcpserver_on_write(self, c) if @delegate
  end

  def tcpServerClientErrorOccured(c)
    @delegate.tcpserver_on_error(self, c, c.error) if @delegate
    close_client(c)
  end
end
