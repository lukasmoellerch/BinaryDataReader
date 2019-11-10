import Foundation
import BinaryUtilities

open class BinaryDataReader {
    public enum BinaryDataReaderError: Error {
        case eof
        case stringDecodingFailed
    }
    public let source: BinaryDataSource
    public init(dataSource: BinaryDataSource) {
        self.source = dataSource
    }
    public func read() throws -> Byte {
        if let byte = source.read() {
            return byte
        }
        throw BinaryDataReaderError.eof
    }
    public func read2() throws -> (Byte, Byte) {
        return (try read(), try read())
    }
    public func read4() throws -> (Byte, Byte, Byte, Byte) {
        return (try read(), try read(), try read(), try read())
    }
    public func read8() throws -> (Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte) {
        return (try read(), try read(), try read(), try read(), try read(), try read(), try read(), try read())
    }
    public func readUInt8() throws -> UInt8 {
        return try read()
    }
    public func readInt8() throws -> Int8 {
        return Int8(bitPattern: try read())
    }
    public func readUInt16() throws -> UInt16 {
        let (a, b) = try read2()
        var res: UInt16 = 0
        res |= UInt16(b) << 8
        res |= UInt16(a)
        return res
    }
    public func readInt16() throws -> Int16 {
        return Int16(bitPattern: try readUInt16())
    }
    public func readUInt32() throws -> UInt32 {
        let (a, b, c, d) = try read4()
        var res: UInt32 = 0
        res |= UInt32(d) << 24
        res |= UInt32(c) << 16
        res |= UInt32(b) << 8
        res |= UInt32(a)
        return res
    }
    public func readInt32() throws -> Int32 {
        return Int32(bitPattern: try readUInt32())
    }
    public func readUInt64() throws -> UInt64 {
        let (a, b, c, d, e, f, g, h) = try read8()
        var res: UInt64 = 0
        res |= UInt64(h) << 56
        res |= UInt64(g) << 48
        res |= UInt64(f) << 40
        res |= UInt64(e) << 32
        res |= UInt64(d) << 24
        res |= UInt64(c) << 16
        res |= UInt64(b) << 8
        res |= UInt64(a)
        return res
    }
    public func readInt64() throws -> Int64 {
        return Int64(bitPattern: try readUInt64())
    }
    public func readFloat32() throws -> Float32 {
        return Float32(bitPattern: try readUInt32())
    }
    public func readFloat64() throws -> Float64 {
        return Float64(bitPattern: try readUInt64())
    }
    public func readULEB128() throws -> UInt64 {
        var result: UInt64 = 0
        var shift: UInt64 = 0
        var byte: Byte = 0
        repeat {
            byte = try read()
            result |= UInt64(byte & 0x7f) << shift
            shift += 7
        } while (byte & 0x80) != 0
        return result
    }
    public func readSLEB128() throws -> Int64 {
        var result: Int64 = 0
        var shift: UInt64 = 0
        var byte: Byte = 0
        let size = 64
        repeat {
            byte = try read()
            result |= Int64(byte & 0x7f) << shift
            shift += 7
        } while (byte & 0x80) != 0
        if shift < size && (byte & 0x40) != 0 {
            result |= -(Int64(1) << shift)
        }
        return result
    }
    public func skip(numberOfBytes: Int) throws {
        for _ in 0..<numberOfBytes {
            _ = try read()
        }
    }
    public func readArray(numberOfBytes: Int) throws -> [Byte] {
        var result = [Byte]()
        for _ in 0..<numberOfBytes {
            result.append(try read())
        }
        return result
    }
    public func readData(numberOfBytes: Int) throws -> Data {
        return Data(try readArray(numberOfBytes: numberOfBytes))
    }
    public func readFixedLengthString(numberOfBytes: Int) throws -> String {
        if let string = String(data: try readData(numberOfBytes: numberOfBytes), encoding: .utf8) {
            return string
        }
        throw BinaryDataReaderError.stringDecodingFailed
    }
    public func readName() throws -> String {
        let length = try readULEB128()
        return try readFixedLengthString(numberOfBytes: Int(length))
    }
}
