//
//  CMULoader.swift
//
//  Created by Camo_u on 2017. 1. 11..
//  Copyright © 2017년 Camo_u. All rights reserved.
//


import UIKit

public typealias ProgressHandler = (Progress) -> Void

@discardableResult
public func load(fromURL url:String) -> CMULoaderManager
{
    return CMULoaderManager.default.load(fromURL: url)
}

open class CMULoaderManager
{
    open static let `default`: CMULoaderManager = {
        return CMULoaderManager()
    }()
    
    let delegate = CMUDataDelegate()
    open var progress: Progress { return delegate.progress }
    @discardableResult
    open func progress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping ProgressHandler) -> Self {
        delegate.progressHandler = (closure, queue)
        return self
    }
    
    @discardableResult
    open func load(fromURL url:String) -> Self
    {
        delegate.session.dataTask(with: NSURL(string: url)! as URL).resume()
        return self
    }
}

class CMUDataDelegate: NSObject, URLSessionDataDelegate
{
    //progress / handler
    var progress: Progress
    var progressHandler: (closure: ProgressHandler, queue: DispatchQueue)?
    
    public var session:URLSession!
    private var totalBytesReceived: Int64 = 0
    
    func reset() {
        progress = Progress(totalUnitCount: 0)
    }
    
    override init() {
        progress = Progress(totalUnitCount: 0)
        super.init()
        session = URLSession(configuration: URLSessionConfiguration.default, delegate:self, delegateQueue: nil)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        let bytesReceived = Int64(data.count)
        totalBytesReceived += bytesReceived
        let totalBytesExpected = dataTask.response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
        
        progress.totalUnitCount = totalBytesExpected
        progress.completedUnitCount = totalBytesReceived
        
        if let progressHandler = progressHandler {
            progressHandler.queue.async { progressHandler.closure(self.progress) }
        }
    }
}
