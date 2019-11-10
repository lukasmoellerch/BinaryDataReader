import XCTest
import BinaryUtilities
@testable import BinaryDataReader

final class BinaryDataReaderTests: XCTestCase {
    func testRead() {
        let dataSource = ArrayDataSource(buffer: [12, 13, 42])
        let reader = BinaryDataReader(dataSource: dataSource)
        XCTAssertEqual(try reader.read(), 12)
        XCTAssertEqual(try reader.read(), 13)
        XCTAssertEqual(try reader.read(), 42)
    }
    func testRead2() throws {
        let dataSource = ArrayDataSource(buffer: [12, 13, 42, 65])
        let reader = BinaryDataReader(dataSource: dataSource)
        let (a, b) = try reader.read2()
        XCTAssertEqual(a, 12)
        XCTAssertEqual(b, 13)
        let (c, d) = try reader.read2()
        XCTAssertEqual(c, 42)
        XCTAssertEqual(d, 65)
    }
    func testRead4() throws {
        let dataSource = ArrayDataSource(buffer: [12, 13, 42, 65])
        let reader = BinaryDataReader(dataSource: dataSource)
        let (a, b, c, d) = try reader.read4()
        XCTAssertEqual(a, 12)
        XCTAssertEqual(b, 13)
        XCTAssertEqual(c, 42)
        XCTAssertEqual(d, 65)
    }
    func testRead8() throws {
        let dataSource = ArrayDataSource(buffer: [12, 13, 42, 65, 1, 2, 3, 4])
        let reader = BinaryDataReader(dataSource: dataSource)
        let (a, b, c, d, e, f, g, h) = try reader.read8()
        XCTAssertEqual(a, 12)
        XCTAssertEqual(b, 13)
        XCTAssertEqual(c, 42)
        XCTAssertEqual(d, 65)
        XCTAssertEqual(e, 1)
        XCTAssertEqual(f, 2)
        XCTAssertEqual(g, 3)
        XCTAssertEqual(h, 4)
    }
    func testReadNumbers() throws {
        var dataSource = ArrayDataSource(buffer: [12])
        var reader = BinaryDataReader(dataSource: dataSource)
        XCTAssertEqual(try reader.readUInt8(), 12)
        
        dataSource = ArrayDataSource(buffer: [UInt8(bitPattern: -12)])
        reader = BinaryDataReader(dataSource: dataSource)
        XCTAssertEqual(try reader.readInt8(), -12)
        
        dataSource = ArrayDataSource(buffer: [0x12, 0x34])
        reader = BinaryDataReader(dataSource: dataSource)
        XCTAssertEqual(try reader.readUInt16(), 0x3412)
        
        dataSource = ArrayDataSource(buffer: [0x12, 0x34])
        reader = BinaryDataReader(dataSource: dataSource)
        XCTAssertEqual(try reader.readInt16(), 0x3412)
        
        dataSource = ArrayDataSource(buffer: [0x12, 0x34, 0x56, 0x78])
        reader = BinaryDataReader(dataSource: dataSource)
        XCTAssertEqual(try reader.readUInt32(), 0x78563412)
        
        dataSource = ArrayDataSource(buffer: [0x12, 0x34, 0x56, 0x78])
        reader = BinaryDataReader(dataSource: dataSource)
        XCTAssertEqual(try reader.readInt32(), 0x78563412)
        
        dataSource = ArrayDataSource(buffer: [0x12, 0x34, 0x56, 0x78, 0x12, 0x34, 0x56, 0x78])
        reader = BinaryDataReader(dataSource: dataSource)
        XCTAssertEqual(try reader.readUInt64(), 0x7856341278563412)
        
        dataSource = ArrayDataSource(buffer: [0x12, 0x34, 0x56, 0x78, 0x12, 0x34, 0x56, 0x78])
        reader = BinaryDataReader(dataSource: dataSource)
        XCTAssertEqual(try reader.readInt64(), 0x7856341278563412)
    }

    static var allTests = [
        ("testRead", testRead),
        ("testRead2", testRead2),
        ("testRead4", testRead4),
        ("testRead8", testRead8),
        ("testReadNumbers", testReadNumbers)
    ]
}
