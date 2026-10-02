package com.govind.expensetracker.entity;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
@Entity @Table(name="transactions", indexes={@Index(name="idx_transaction_date",columnList="transaction_date"),@Index(name="idx_transaction_type",columnList="type"),@Index(name="idx_transaction_category",columnList="category")})
public class Transaction {
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private Long id;
 @Enumerated(EnumType.STRING) @Column(nullable=false,length=10) private TransactionType type;
 @Column(nullable=false,length=80) private String category;
 @Column(nullable=false,length=120) private String title;
 @Column(nullable=false,precision=12,scale=2) private BigDecimal amount;
 @Column(name="transaction_date",nullable=false) private LocalDate transactionDate;
 @Column(length=500) private String note;
 @Column(nullable=false,updatable=false) private LocalDateTime createdAt;
 @Column(nullable=false) private LocalDateTime updatedAt;
 @PrePersist void create(){createdAt=LocalDateTime.now();updatedAt=createdAt;}
 @PreUpdate void update(){updatedAt=LocalDateTime.now();}
 public Long getId(){return id;} public void setId(Long v){id=v;}
 public TransactionType getType(){return type;} public void setType(TransactionType v){type=v;}
 public String getCategory(){return category;} public void setCategory(String v){category=v;}
 public String getTitle(){return title;} public void setTitle(String v){title=v;}
 public BigDecimal getAmount(){return amount;} public void setAmount(BigDecimal v){amount=v;}
 public LocalDate getTransactionDate(){return transactionDate;} public void setTransactionDate(LocalDate v){transactionDate=v;}
 public String getNote(){return note;} public void setNote(String v){note=v;}
}
